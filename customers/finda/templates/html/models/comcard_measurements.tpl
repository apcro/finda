<div class="measurements" style="color: #000; width: 100%; text-align: center; margin-top: 16px;">
Height: <b>{$model.profile.height}</b>
{if $model.gender eq 'female'}
Bust: <b>{$model.profile.bust}</b>
{/if}
Waist: <b>{$model.profile.waist}</b>
Hips: <b>{$model.profile.hips}</b>
{if $model.gender eq 'female'}
Dress: <b>{$model.profile.dresssize}</b>
{else}
Suit: <b>{$model.profile.suitsize}</b>
{/if}
Shoe: <b>{$model.profile.shoesize}</b>
Hair: <b>{$model.profile.haircolour}</b>
Eyes: <b>{$model.profile.eyecolour}</b>
</div>
