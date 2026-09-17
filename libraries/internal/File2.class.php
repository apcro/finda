<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

class File2 extends Core {
	static $core;

	/**
	 * Destruct object
	 * 
	 * @return void
	 */
	public function __destruct() {
		self::Close();
	}
	/**
	 * Initialise.
	 * 
	 * @return
	 */
	public static function Initialise() {
		if (!isset(self::$core)) {
			if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
			self::$core = parent::Initialise();
		}
		return self::$core;
	}

	static $name = null;
	static $info = array();
	static $handle = null;
	static $lock = null;
	static $path = null;


	/**
	 * Opens the current file with a given $mode
	 * Must be called before using most other functions
	 *
	 * @param string $mode A valid 'fopen' mode string (r|w|a ...)
	 * @param boolean $force If true then the file will be re-opened even if its already opened, otherwise it won't
	 * @return boolean True on success, false on failure
	 * @access public
	 */
	static function Open($file, $mode = 'r') {
		clearstatcache();
		if (self::_exists() === false) {
			if (self::_create() === false) {
				return false;
			}
		}
		self::$path = $file;
		self::$handle = fopen(self::$path, $mode);
		if (is_resource(self::$handle)) {
			return true;
		}
		return false;
	}

	/**
	 * Return the contents of this File as a string.
	 *
	 * @param string $bytes where to start
	 * @param string $mode
	 * @param boolean $force If true then the file will be re-opened even if its already opened, otherwise it won't
	 * @return mixed string on success, false on failure
	 * @access public
	 */
	static function Read($bytes = false, $mode = 'rb', $force = false) {
		if (!is_resource(self::$handle)) {
			return false;
		}
		if ($bytes === false && self::$lock === null) {
			return file_get_contents(self::$path);
		}

		if (self::$lock !== null && flock(self::$handle, LOCK_SH) === false) {
			return false;
		}
		if (is_int($bytes)) {
			return fread(self::$handle, $bytes);
		}

		$data = '';
		while (!feof(self::$handle)) {
			$data .= fgets(self::$handle, 4096);
		}
		$data = trim($data);

		if (self::$lock !== null) {
			flock(self::$handle, LOCK_UN);
		}
		if ($bytes === false) {
			self::Close();
		}
		return $data;
	}

	/**
	 * Close file
	 * 
	 * @return bool
	 */
	static function Close() {
		if (!is_resource(self::$handle)) {
			return true;
		}
		return fclose(self::$handle);
	}

	/**
	 * Delete file.
	 * 
	 * @param string $file file location
	 * @return bool
	 */
	static function Delete($file = '') {
		if (empty($file)) {
			$file = self::$path;
		}
		clearstatcache();
		if (self::Exists($file)) {
			return unlink($file);
		}
		return false;
	}

	/**
	 * Get file info
	 * 
	 * @return array
	 */
	static function Info() {
		if (self::$info == null) {
			self::$info = pathinfo(self::$path);
		}
		if (!isset(self::$info['filename'])) {
			self::$info['filename'] = self::Name();
		}
		return self::$info;
	}

	/**
	 * Get file extension.
	 * 
	 * @return string
	 */
	static function Extension() {
		if (self::$info == null) {
			self::Info();
		}
		if (isset(self::$info['extension'])) {
			return self::$info['extension'];
		}
		return false;
	}

	/**
	 * Get file name.
	 * 
	 * @return string
	 */
	static function Name() {
		if (self::$info == null) {
			self::Info();
		}
		if (isset(self::$info['extension'])) {
			return basename(self::$name, '.'.self::$info['extension']);
		} elseif (self::$name) {
			return self::$name;
		}
		return false;
	}

	/**
	 * Chcek file exists.
	 * 
	 * @param string $file file path.
	 * @return bool
	 */
	static function Exists($file = '') {
		if (empty($file)) {
			$file = self::$path;
		}
		return (file_exists($file) && is_file($file));
	}

	/**
	 * Get file size
	 * 
	 * @param string $file file path
	 * @return int
	 */
	static function Size($file = '') {
		if (empty($file)) {
			$file = self::$path;
		}
		if (self::Exists($file)) {
			return filesize($file);
		}
		return false;
	}

	/**
	 * Update file to $dest
	 * 
	 * @param string $destination destination for the copy
	 * @return string file location
	 */
	final static public function Upload($destination) {
		if ((!file_exists($destination) || !is_dir($destination))) {
			$res = mkdir($destination, 0777, true);
		}

		$files = (!empty($_FILES)) ? $_FILES : array();

		$indest = $destination;

		foreach($files as $filekey => $file) {
			$fileext = pathinfo($file['name'], PATHINFO_EXTENSION);
			if (empty($fileext)) {
				// determine from exif data
				$exiftype = exif_imagetype($file['tmp_name']);
				switch($exiftype) {
					case IMAGETYPE_BMP:
						$fileext = 'bmp';
						break;
					case IMAGETYPE_GIF:
						$fileext = 'gif';
						break;
					case IMAGETYPE_JPEG:
					case IMAGETYPE_JPEG2000:
						$fileext = 'jpg';
						break;
					case IMAGETYPE_PNG:
						$fileext = 'png';
						break;
				}
			}
			$filename = strrev(uniqid()).'.'.$fileext;
			$newdir = $destination.'/'.substr($filename,0,2).'/'.substr($filename,2,2);
			mkdir($newdir, 0777, true);
			$newname = $newdir . '/' . $filename;
			if (!move_uploaded_file($file['tmp_name'], $newname)) {

				$response = array();
				$response['errorMessage'] = 'Could not move file';
				$response['destination'] = $destination;
				$response['newdir'] = $newdir;
				$response['newname'] = $newname;
				$response['file'] = $file;

				return $response;
			}
			self::correctImageOrientation($newname);
			return array('originalname' => $file['name'], 'newname' => $newname);
		}
	}
	/**
	 * Copy the File to $dest
	 *
	 * @param string $dest destination for the copy
	 * @param boolean $overwrite Overwrite $dest if exists
	 * @return boolean Succes
	 * @access public
	 */
	static function Copy($dest, $overwrite = true) {
		if (!self::Exists() || is_file($dest) && !$overwrite) {
			return false;
		}
		return copy(self::$path, $dest);
	}

	/**
	 * Load a complete record for a given file
	 *
	 * @param $id int file id of the file in question
	 * @return array
	 */
	function LoadFile($fid) {
		$response = ds('files_LoadFile', array(
				'fid' => $fid
		));
		if(isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}

	/**
	 * Add a file record
	 *
	 * @param $type string file type
	 * @param $title string file title
	 * @param $teaser string teaser
	 * @param $body string file body text
	 * @param $format int format of the body text
	 * @param $filename string file name
	 * @param $filepath string server path to the file
	 * @param $filemime string mime type of the file
	 * @param $filesize int file size in bytes
	 * @param $istvguide boolean is this a tv guide (tid 585)
	 * @return boolean
	 */
	function AddFile($type, $title, $teaser, $body, $format, $filename, $filepath, $filemime, $filesize, $uid=0, $publish_status=0) {
		$response = ds('files_AddFile', array(
				'type' 		     => $type,
				'title' 		 => $title,
				'teaser' 		 => $teaser,
				'body' 		     => $body,
				'format' 		 => $format,
				'filename' 	     => $filename,
				'filepath' 	     => $filepath,
				'filemime' 	     => $filemime,
				'filesize' 	   	 => $filesize,
				'uid'			 => $uid,
				'publish_status' => $publish_status
		));
		if(isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result']; // contains the new nid
		} else {
			return false;
		}
	}

	/**
	 * Update a file record
	 *
	 * @param $fid int file id of the record to be updated
	 * @param $nid int node id of the record to be updated
	 * @param $type string file type
	 * @param $title string file title
	 * @param $teaser string teaser
	 * @param $body string file body text
	 * @param $format int format of the body text
	 * @param $filesize int size in bytes of the uploaded file
	 * @param $istvguide boolean is this a tv guide (tid 585)
	 * @return boolean
	 */
	function UpdateFile($fid, $nid, $type, $title, $teaser, $body, $format, $filename, $filepath, $filemime, $filesize, $taxonomy=false, $update_status=0) {
		$response = ds('files_UpdateFile', array(
				'fid' 			=> $fid,
				'nid' 			=> $nid,
				'type' 			=> $type,
				'title' 		=> $title,
				'teaser' 		=> $teaser,
				'body' 			=> $body,
				'format' 		=> $format,
				'filename'     	=> $filename,
				'filepath'     	=> $filepath,
				'filemime'     	=> $filemime,
				'filesize' 		=> $filesize,
				'taxonomy' 		=> $taxonomy,
				'update_status'	=> $update_status
		));
		if(isset($response['statusCode']) && $response['statusCode'] == 0) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Deletes a given file record
	 *
	 * @param $fid int file id of the file in question
	 * @param $nid int file id of the file in question
	 * @return array
	 */
	function DeleteFile($fid, $nid) {
		$response = ds('files_DeleteFile', array(
				'fid' => $fid,
				'nid' => $nid
		));
		if(isset($response['statusCode']) && $response['statusCode'] == 0) {
			return true;
		} else {
			return false;
		}
	}
	
	function Stream($filename, $retbytes = TRUE) {
		$buffer = '';
		$cnt    = 0;
		$handle = fopen($filename, 'rb');
		
		if ($handle === false) {
			return false;
		}
		
		while (!feof($handle)) {
			$buffer = fread($handle, 1024*1024);
			echo $buffer;
			ob_flush();
			flush();
			
			if ($retbytes) {
				$cnt += strlen($buffer);
			}
		}
		
		$status = fclose($handle);
		
		if ($retbytes && $status) {
			return $cnt; // return num. bytes delivered like readfile() does.
		}
		
		return $status;
	}
	
	public static function correctImageOrientation($filename) {
		if (function_exists('exif_read_data')) {
			$exif = exif_read_data($filename);
			if ($exif && isset($exif['Orientation'])) {
				$orientation = $exif['Orientation'];
				if ($orientation != 1) {
					
					$fileInfo = pathinfo($filename);
					$extension = strtolower($fileInfo['extension']);
					
					switch($extension){
						case 'png':
							$img = imagecreatefrompng($filename);
							break;
						case 'jpg':
						case 'jpeg':
							$img = imagecreatefromjpeg($filename);
							break;
						case 'gif':
							$img = imagecreatefromgif($filename);
							break;
						case 'bmp':
							$img = imagecreatefrombmp($filename);
							break;
						default:
							//throw expception
							$img = false;
							break;
					}
					$deg = 0;
					switch ($orientation) {
						case 3:
							$deg = 180;
							break;
						case 6:
							$deg = 270;
							break;
						case 8:
							$deg = 90;
							break;
					}
					if ($deg) {
						$img = imagerotate($img, $deg, 0);
					}
					switch($extension){
						case 'png':
							imagepng($img, $filename, -1);
							break;
						case 'jpg':
						case 'jpeg':
							imagejpeg($img, $filename, 100);
							break;
						case 'gif':
							imagegif($img, $filename);
							break;
						case 'bmp':
							imagewbmp($img, $filename);
							break;
						default:
							break;
					}
				}
			}
		}
	}
}