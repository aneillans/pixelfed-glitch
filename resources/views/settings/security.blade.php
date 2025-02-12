@extends('settings.template')

@section('section')

  <div class="title">
    <h3 class="font-weight-bold">{{__('settings.security')}}</h3>
  </div>
  <hr>

  <section class="pt-4">
    <div class="mb-4 pb-4">
      <div class="d-flex justify-content-between align-items-center">
        <h4 class="font-weight-bold mb-0">{{__('settings.security.two_factor_authentication')}}</h4>
        @if($user->{'2fa_enabled'})
        <a class="btn btn-success btn-sm font-weight-bold" href="#">{{__('settings.security.enabled')}}</a>
        @endif
      </div>
      <hr>
      @if($user->{'2fa_enabled'})
      @include('settings.security.2fa.partial.edit-panel')
      @else
      @include('settings.security.2fa.partial.disabled-panel')
      @endif
    </div>

    @include('settings.security.log-panel')
    
    @include('settings.security.device-panel')

    @if(config('pixelfed.account_deletion') && !$user->is_admin)
    <h4 class="font-weight-bold pt-3">{{__('settings.security.danger_zone')}}</h4>
    <div class="mb-4 border rounded border-danger">
      <ul class="list-group mb-0 pb-0">
        <li class="list-group-item border-left-0 border-right-0 py-3 d-flex justify-content-between">
          <div>
            <p class="font-weight-bold mb-1">{{__('settings.security.temporarily_disable_account')}}</p>
            <p class="mb-0 small">{{__('settings.security.disable_your_account_to_hide_your_posts_until_next_log_in')}}</p>
          </div>
          <div>
            <a class="btn btn-outline-danger font-weight-bold py-1" href="{{route('settings.remove.temporary')}}">{{__('settings.security.disable')}}</a>
          </div>
        </li>
        <li class="list-group-item border-left-0 border-right-0 py-3 d-flex justify-content-between">
          <div>
            <p class="font-weight-bold mb-1">{{__('settings.security.delete_this_account')}}</p>
            <p class="mb-0 small">{{__('settings.security.once_you_delete_your_account_there_is_no_going_back_etc')}}</p>
          </div>
          <div>
            <a class="btn btn-outline-danger font-weight-bold py-1" href="{{route('settings.remove.permanent')}}">{{__('settings.security.delete')}}</a>
          </div>
        </li>
      </ul>
    </div>
    @endif
  </section>

@endsection