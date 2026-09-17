	<div class="comcard page2">
		
		<table class="text-center" style="width: 100%; font-size: 16px; border-collapse: inherit; border-spacing: 0 16px;">
			<tr><td colspan="3">&nbsp;</td></tr>
			<tr>
				<td colspan="3"><h1>{$model.firstname} {$model.lastname|substr:0:1}.</h1></td>
			</tr>
			<tr><td colspan="3">&nbsp;</td></tr>
			<tr><td colspan="3">&nbsp;</td></tr>
			<tr style="text-align: center;">
				<td style="width: 30%; text-align: right; padding-right: 16px;">Age</td>
				<td style="width: 40%"><hr class="yellow-line"></td>
				<td style="width: 30%; text-align: left; padding-left: 16px;">{$model.age}</td>
			</tr>
			<tr>
				<td style="width: 30%; text-align: right; padding-right: 16px;">Height</td>
				<td style="width: 40%"><hr class="yellow-line"></td>
				<td style="width: 30%; text-align: left; padding-left: 16px;">{$model.profile.height}</td>
			</tr>
			<tr>
				<td style="width: 30%; text-align: right; padding-right: 16px;">Bust</td>
				<td style="width: 40%"><hr class="yellow-line"></td>
				<td style="width: 30%; text-align: left; padding-left: 16px;">{$model.profile.bust}</td>
			</tr>
			<tr>
				<td style="width: 30%; text-align: right; padding-right: 16px;">Waist</td>
				<td style="width: 40%"><hr class="yellow-line"></td>
				<td style="width: 30%; text-align: left; padding-left: 16px;">{$model.profile.waist}</td>
			</tr>
			<tr>
				<td style="width: 30%; text-align: right; padding-right: 16px;">Hips</td>
				<td style="width: 40%"><hr class="yellow-line"></td>
				<td style="width: 30%; text-align: left; padding-left: 16px;">{$model.profile.hips}</td>
			</tr>
			<tr>
				<td style="width: 30%; text-align: right; padding-right: 16px;">Dress</td>
				<td style="width: 40%"><hr class="yellow-line"></td>
				<td style="width: 30%; text-align: left; padding-left: 16px;">{$model.profile.dresssize}&nbsp;UK</td>
			</tr>
			<tr>
				<td style="width: 30%; text-align: right; padding-right: 16px;">Shoe</td>
				<td style="width: 40%"><hr class="yellow-line"></td>
				<td style="width: 30%; text-align: left; padding-left: 16px;">{$model.profile.shoesize}&nbsp;UK</td>
			</tr>
			<tr>
				<td style="width: 30%; text-align: right; padding-right: 16px;">Hair</td>
				<td style="width: 40%"><hr class="yellow-line"></td>
				<td style="width: 30%; text-align: left; padding-left: 16px;">{$model.profile.haircolour}</td>
			</tr>
			<tr>
				<td style="width: 30%; text-align: right; padding-right: 16px;">Eyes</td>
				<td style="width: 40%"><hr class="yellow-line"></td>
				<td style="width: 30%; text-align: left; padding-left: 16px;">{$model.profile.eyecolour}</td>
			</tr>
			<tr><td colspan="3">&nbsp;</td></tr>
			<tr><td colspan="3">&nbsp;</td></tr>
		</table>
		<table class="text-center" style="width: 100%; font-size: 16px; border-collapse: inherit; border-spacing: 0;">
			<tr style="width: 80%; text-align: center;">
				<td style="line-height: 16px; font-weight: bold;">
					<img src="/images/instagram.png" width=16 height=16 style="position: relative; margin-top: 3px; margin-right: 8px;" />{$model.instagram_followers|number_format:0:".":","}
				</td>
			</tr>
			<tr style="width: 80%; text-align: center;">
				<td><hr style="width: 80%; height: 2px; background-color: #59c5cf; border: none;"></td>
			</tr>
			<tr style="width: 80%; text-align: center;">
				<td style="font-weight: bold;">{$model.instagram_username}</td>
			</tr>
		</table>
	</div>
