{if isset($avatar_message)}
    <div class="message {$avatar_message_class}">{$avatar_message}</div>
{/if}
{* {if $iPad}
    <div class="message alert" style="margin-top: 10px;">Sorry, you cannot change your Avatar using an iPad.</div>
{else} *}
    <form id="avatar_form" action="/user/profile/avatar" class="register" method="post" enctype="multipart/form-data">
        <input type="hidden" name="avatar_form" value="1" />
        <p>You are using the default profile photo, you may use the form below to select a custom one.</p>
        <span>
            <label class="required">Upload a new profile photo (jpeg format only, 128 mb max):</label>
            <input type="hidden" name="MAX_FILE_SIZE" value="{$uploadlimit}" />
            <input type="file" name="avatar" id="avatar" style="display: inline;" />
        </span>
        <div class="submit_button">
            <input class="button" type="submit" value="Upload profile photo"/>
        </div>
    </form>
{* {/if} *}