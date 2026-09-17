<div class="grid profile-home">
	<div class="grid-left">
		<div class="row">
			<div class="column">
			</div>
			<div class="column">
				<h1 class="align-left"><strong>{$model.firstname}</strong></h1>
				<h2>{$model.lastname}</h2>
			</div>
		</div>
		<div class="row">
			<div class="column">
			</div>
			<div class="column">
				<div class="row">
					<div class="column">
						<a href="/user/portfolio">portfolio</a>
					</div>
					<div class="column">
						<a href="/user/poloaroids">poloaroids</a>
					</div>
				</div>
				<div class="row">
					<div class="column">Age</div>
					<div class="column"><hr class="yellow-line"></div>
					<div class="column">{$model.age}</div>
				</div>

				<div class="row">
					<div class="column">Height</div>
					<div class="column"><hr class="yellow-line"></div>
					<div class="column">{$model.profile.height}</div>
				</div>
				<div class="row">
					<div class="column">Bust</div>
					<div class="column"><hr class="yellow-line"></div>
					<div class="column">{$model.profile.bustsize}</div>
				</div>
				<div class="row">
					<div class="column">Waist</div>
					<div class="column"><hr class="yellow-line"></div>
					<div class="column">{$model.profile.waistsize}</div>
				</div>
				<div class="row">
					<div class="column">Hips</div>
					<div class="column"><hr class="yellow-line"></div>
					<div class="column">{$model.profile.hipssize}</div>
				</div>
				<div class="row">
					<div class="column">Dress</div>
					<div class="column"><hr class="yellow-line"></div>
					<div class="column">{$model.profile.dresssize}</div>
				</div>
				<div class="row">
					<div class="column">Shoe</div>
					<div class="column"><hr class="yellow-line"></div>
					<div class="column">{$model.profile.shoesize}</div>
				</div>
				<div class="row">
					<div class="column">Hair</div>
					<div class="column"><hr class="yellow-line"></div>
					<div class="column">{$model.profile.haircolour}</div>
				</div>
				<div class="row">
					<div class="column">Eyes</div>
					<div class="column"><hr class="yellow-line"></div>
					<div class="column">{$model.profile.eyecolour}</div>
				</div>

			</div>
		</div>
	</div>
	<div class="grid-main">
		<div class="full-bleed">
			<img src="{$user_avatar}" />
		</div>
	</div>
</div>
