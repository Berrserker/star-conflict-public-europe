-- ----------------------------------------------------------------------------
--
-- Workfile: loginwnd.lua
-- Copyright © 2006, Targem LLC. All rights reserved.
-- --
-- ----------------------------------------------------------------------------
--  $Id:  $
-- ----------------------------------------------------------------------------

local resolution = UI:GetCoordinateSystemForAspect( UI.screenHeight / UI.screenWidth )

UI.LoginWnd = {}
local lw = UI.LoginWnd

-- --------------------------------------
-- window definiiton
-- --------------------------------------

UI.LoginWnd.def =
{
	className	= "Wnd",
	prototype	= "FullScreenSelectionWnd",

	props =
	{
		name	= "LoginWnd",
		style	= UI.WS_UPDATE_IF_VISIBLE + UI.WS_REDIRECT_ACTIVATION_TO_CHILDREN,
	},

	layers =
	{
		-- MAIN_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,
			main		= true,

			effects =
			{{
				defName				= "login_main",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "login_bg_2",
						layer		= "UI.LoginWnd.layers.BG_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "bg",
						layer		= "UI.LoginWnd.layers.BG2_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "login_bg_3",
						layer		= "UI.LoginWnd.layers.BG3_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "login_slot1",
						layer		= "UI.LoginWnd.layers.ACCOUNT_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "login_slot2",
						layer		= "UI.LoginWnd.layers.PASSWORD_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "registr",
						wnd			= "UI.Login_RegisterBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "forgot",
						wnd			= "UI.Login_ForgetBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "exit",
						wnd			= "UI.Login_QuitBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "enter",
						wnd			= "UI.Login_LogInBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "remember",
						wnd			= "UI.Login_RememberCheckBox",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "drop_down_main",
						wnd			= "UI.Login_ServersComboBox",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "btn_2_3",
						wnd			= "UI.Login_OptionsBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "btn_2_5",
						wnd			= "UI.Login_LicenseBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "btn_2_2",
						wnd			= "UI.Login_CreditsBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "btn_2_4",
						wnd			= "UI.Login_SiteBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "version",
						layer		= "UI.LoginWnd.layers.BUILD_VERSION",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "warning",
						layer		= "UI.LoginWnd.layers.WARNING",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "news",
						wnd			= "UI.NewsWnd",
						animParams	= UI.EffectAnimParams.POS,
					},

					--[[{
						objName		= "btn_2_1",
						wnd			= "UI.Login_SupportBtn",
						animParams	= UI.EffectAnimParams.POS,
					},]]

					{
						objName		= "btn_2_1",
						wnd			= "UI.Login_StartServerBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "status_server",
						layer		= "UI.LoginWnd.layers.SERVER_STATUS",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "enter_2",
						wnd			= "UI.Login_SteamLogInBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "enter_2",
						wnd			= "UI.Login_ArcLogInBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "text_2",
						layer		= "UI.LoginWnd.layers.STEAM_LOGIN_TIP",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "text_2",
						layer		= "UI.LoginWnd.layers.ARC_LOGIN_TIP",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "version1",
						layer		= "UI.LoginWnd.layers.PATCH_NAME",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "btn_2_6",
						wnd			= "UI.Login_PrivacyPolicyBtn",
						animParams	= UI.EffectAnimParams.POS,
					},
					
					{
						objName		= "btn_2_7",
						wnd			= "UI.Login_TermsOfUseBtn",
						animParams	= UI.EffectAnimParams.POS,
					},
				}
			}}
		}, 

		-- BG_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_bg",
				defaultAnimation    = "idle",
			}}
		},

		-- BG2_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_bg2",
				defaultAnimation    = "idle",
			}}
		},

		-- BG3_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_bg3",
				defaultAnimation    = "idle",
			}}
		},

		-- ACCOUNT_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_inputSlot",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "name",
						layer		= "UI.LoginWnd.layers.ACCOUNT_LABEL",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "login_input",
						wnd			= "UI.Login_AccountEditWnd",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.ALPHA,
					},
				}
			}}
		},

		-- ACCOUNT_LABEL
		{
			layerType	= UI.LAYER_TEXT,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
			text = ( UI:GetLanguage() == "RUSSIAN" ) and "\208\155\208\190\208\179\208\184\208\189" or "Login",
		}, 

		-- PASSWORD_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_inputSlot",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "name",
						layer		= "UI.LoginWnd.layers.PASSWORD_LABEL",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "login_input",
						wnd			= "UI.Login_PasswordEditWnd",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.ALPHA,
					},
				}
			}}
		}, 

		-- PASSWORD_LABEL
		{
			layerType	= UI.LAYER_TEXT,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
			text = "^login_passwordLabel",
		}, 

		-- BUILD_VERSION
		{
			layerType	= UI.LAYER_TEXT,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
		}, 

		-- WARNING
		{
			layerType	= UI.LAYER_TEXT,
			layerStyle	= UI.WLS_OWNERDRAW,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
		}, 

		-- SERVER_STATUS
		{
			layerType	= UI.LAYER_TEXT,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
		}, 

		-- STEAM_LOGIN_TIP
		{
			layerType	= UI.LAYER_TEXT,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
			text = UI:GetStringByName( "login_steamLoginTip" )
		}, 

		-- ARC_LOGIN_TIP
		{
			layerType	= UI.LAYER_TEXT,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
			text = UI:GetStringByName( "login_arcLoginTip" )
		}, 

		-- PATCH_NAME
		{
			layerType	= UI.LAYER_TEXT,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
			text = "Star Conflict Classic | Europe - Unofficial Server"
		},
	},

	children =
	{
		"UI.Login_AccountEditWnd",
		"UI.Login_PasswordEditWnd",
		"UI.Login_LogInBtn",
		"UI.Login_ForgetBtn",
		"UI.Login_RegisterBtn",
		"UI.Login_QuitBtn",
		"UI.Login_RememberCheckBox",
		"UI.Login_WaitingWnd",
		"UI.Login_ServersComboBox",
        "UI.Login_OptionsBtn",
        "UI.Login_LicenseBtn",
        "UI.Login_CreditsBtn",
        "UI.Login_SiteBtn",
		"UI.NewsWnd",
		"UI.Login_ConnectingWnd",
		--"UI.Login_SupportBtn",
		"UI.Login_StartServerBtn",
		"UI.Login_SteamImportAccountWnd",
		"UI.Login_ArcImportAccountWnd",
		"UI.Login_SteamLogInBtn",
		"UI.Login_ArcLogInBtn",
		"UI.Login_SteamImportAccountBox",
		"UI.Login_ArcImportAccountBox",
		"UI.Login_TwoStepAuthorisationWnd",
		"UI.Login_PrivacyPolicyBtn",
		"UI.Login_TermsOfUseBtn",
		"UI.Login_ServerNameEditWnd",
		"UI.Login_ServerPortEditWnd",
	}
}


-- --------------------------------------
-- interface functions
-- --------------------------------------

--
function UI.LoginWnd:GameStore_OnLoadingComplete()

	if not self:IsOnScreen() then
		return
	end

	if self.bWaitingStore then

		self.bWaitingStore = false
		self:CheckLoadDataComplete()

	end

end


--
function UI.LoginWnd:GameStore_OnLoadingTimeout()

	if not self:IsOnScreen() then
		return
	end

	if self.bWaitingStore then

		self.bWaitingStore = false
		self:OnLoadDataFail( UI:GetStringByName( "msg_timeOut" ) )

	end

end


--
function UI.LoginWnd:MasterServer_OnInitialPlayerData( result, requestId, param1, param2 )

	if not self:IsOnScreen() then
		return
	end

	self:OnLoadDataRequest( result, requestId )

end


--
function UI.LoginWnd:MasterServer_OnLobbyInfo( result, requestId, param1, param2 )

	if not self:IsOnScreen() then
		return
	end

	self:OnLoadDataRequest( result, requestId )

end


--
function UI.LoginWnd:MasterServer_OnLeaderboardGetDescs( result, requestId, param1, param2 )

	if not self:IsOnScreen() then
		return
	end

	self:OnLoadDataRequest( result, requestId )

end


-- вызывается окном AgreementWnd
function UI.LoginWnd:OnAgreementAccept( result )

	if self.waitMode == self.waitModes.NDA then

		self:HideAgreementWnd()

		if result == UI.AgreementWnd.returnResults.ACCEPT then
    		self:ProceedToHangar()

		elseif result == UI.AgreementWnd.returnResults.REJECT then
    		self:LogOut()

		else
			sys.log( "UI.LoginWnd:OnAgreementAccept()[ERROR]: unhandled result \"%s\"", tostring( result ) )
    	end

	elseif self.waitMode == self.waitModes.EULA then

		if result == UI.AgreementWnd.returnResults.ACCEPT then

			self:CheckShowNextEula( true )

			if self.eulaIdx == -1 then
				local profile = _G.GetProfileTable()
				local curVersion = _G.GetAppVersion()

				profile.eulaAppVersion = curVersion
				Profile:Save()
			end

		elseif result == UI.AgreementWnd.returnResults.REJECT then
			self:QuitGame()

		else
			sys.log( "UI.LoginWnd:OnAgreementAccept()[ERROR]: unhandled result \"%s\"", tostring( result ) )
			self:HideAgreementWnd()
		end

	elseif self.waitMode == self.waitModes.EULA_NOT_NEED_ACCEPT then

		self:CheckShowNextEula( false )

	else
		sys.log( "UI.LoginWnd:OnAgreementAccept()[ERROR]: wrong mode %s", tostring( self.waitMode ) )
	end

end


--
function UI.LoginWnd:MasterServer_OnServerStatus( errcode, status )

	if not self:IsOnScreen() then
		return
	end

	if errcode == 0 then
		self.serverStatus = status
	else
		sys.log( "UI.LoginWnd:MasterServer_OnServerStatus()[ERROR]: fail to retreive server status; error %d", errcode  )
		self.serverStatus = -1
	end

	self:UpdateWarningText()
	self:UpdateServerStatusText()
	self:UpdateLogInBtn()

end


--
function UI.LoginWnd:MasterServer_OnServerVersion( errcode, version )

	if not self:IsOnScreen() then
		return
	end

	if errcode == 0 then
		self.serverVersion = version
	else
		sys.log( "UI.LoginWnd:MasterServer_OnServerVersion()[ERROR]: fail to retreive server version; error %d", errcode  )
		self.serverVersion = "error"
	end

	self:UpdateWarningText()
	self:UpdateLogInBtn()

end


--
function UI.LoginWnd:MasterServer_OnNewsFeed( errcode, items )

	if not self:IsOnScreen() then
		return
	end

	if errcode == 0 then

--[[ DEBUG
		local numNews = #items
		for idx = 2, 10 do
			items[ idx ] = items[ 1 ]
		end
]]

		self.news = items

		if items and next( items ) then
			UI.NewsWnd:Setup( items )
			self:ShowNewsWnd()
		end

	else
		sys.log( "UI.LoginWnd:MasterServer_OnNewsFeed()[ERROR]: fail to get news; error code: %d", errcode )
	end

end


--
function UI.LoginWnd:MasterServer_OnServerAddresess( errcode, servers )

	if not self:IsOnScreen() then
		return
	end

	if errcode ~= 0 then
		sys.log( "UI.LoginWnd:MasterServer_OnServerAddresess()[WARNING]: fail to retreive servers list; error %d", errcode )
	end

	self.servers = self.defaultServers

	self.bWaitServers = false
	self:UpdateServersComboBox()
	self:UpdateWarningText()
	self:UpdateLogInBtn()

end


--
function UI.LoginWnd:MasterServer_OnLoadBalancerQueueInfo( position, guesstimate )

	if not self:IsOnScreen() then
		return
	end

	self.connecting_posInQueue	= position
	self.connecting_timeLeft	= guesstimate

	if self.waitMode == self.waitModes.CONNECTING then
		self:SetWaitMode( self.waitModes.CONNECTING_HANG )	

	elseif self.waitMode == self.waitModes.CONNECTING_HANG then
		UI.Login_ConnectingWnd:Setup( position, guesstimate )

	else
		sys.log( "UI.LoginWnd:MasterServer_OnLoadBalancerQueueInfo()[ERROR]: wrong wait mode: %s", tostring( self.waitMode ) )
	end

end


--
function UI.LoginWnd:MasterServer_OnClanRequestDesc( result, requestId, param1, param2 )

	if not self:IsOnScreen() then
		return
	end
	
	if UI.Clan:IsInClan() then
		if not self:AddRequest( _G.MasterServer_WarMapRequest() ) then
			return
		end
	end

	self:OnLoadDataRequest( result, requestId )

end


--
function UI.LoginWnd:MasterServer_OnSquadInfo( result, requestId, param1, param2 )

	if not self:IsOnScreen() then
		return
	end

	self:OnLoadDataRequest( result, requestId )

end


--
function UI.LoginWnd:MasterServer_OnSocialList( result, requestId, param1, param2 )

	if not self:IsOnScreen() then
		return
	end

	self:OnLoadDataRequest( result, requestId )

end


--
function UI.LoginWnd:MasterServer_OnTeachingList( result, requestId )

	if not self:IsOnScreen() then
		return
	end

	self:OnLoadDataRequest( result, requestId )

end


--
function UI.LoginWnd:MasterServer_OnUserProfileUpdate( result, requestId, uid, field )

	if not self:IsOnScreen() then
		return
	end

	if requestId ~= 0 then
	
		if self.profileRequestId == requestId then
		
			if result == 0 then
				self.profileRequestId = 0
				self:CheckLoadDataComplete()
			else
				self:OnLoadDataFail( UI:GetStringByName( "msg_timeOut" ) )
			end	

		elseif self.profileTitlesRequestId == requestId then
		
			if result == 0 then
				self.profileTitlesRequestId = 0
				self:CheckLoadDataComplete()
			else
				self:OnLoadDataFail( UI:GetStringByName( "msg_timeOut" ) )
			end
			
		elseif self.profileAvatarsRequestId == requestId then
		
			if result == 0 then
				self.profileAvatarsRequestId = 0
				self:CheckLoadDataComplete()
			else
				self:OnLoadDataFail( UI:GetStringByName( "msg_timeOut" ) )
			end
			
		elseif self.profileMottosRequestId == requestId then
		
			if result == 0 then
				self.profileMottosRequestId = 0
				self:CheckLoadDataComplete()
			else
				self:OnLoadDataFail( UI:GetStringByName( "msg_timeOut" ) )
			end
			
		elseif self.profileAtlasRequestId == requestId then
		
			if result == 0 then
				self.profileAtlasRequestId = 0
				self:CheckLoadDataComplete()
			else
				self:OnLoadDataFail( UI:GetStringByName( "msg_timeOut" ) )
			end
			
		end
		
	end

end


--
function UI.LoginWnd:MasterServer_OnMailGet( result, requestId )

	if not self:IsOnScreen() then
		return
	end

	self:OnLoadDataRequest( result, requestId )

end


--
function UI.LoginWnd:MasterServer_OnLeagueTeamInfo( result, requestId, param1, param2 )

	if not self:IsOnScreen() then
		return
	end

	self:OnLoadDataRequest( result, requestId )

end


--
function UI.LoginWnd:MasterServer_OnSteamNotAttached()

	if not self:IsOnScreen() then
		return
	end

	if self.waitMode ~= self.waitModes.CONNECTING and self.waitMode ~= self.waitModes.CONNECTING_HANG then
		sys.log( "UI.LoginWnd:MasterServer_OnSteamNotAttached()[ERROR]: unfit mode: %s", tostring( self.waitMode ) )
		return
	end

	self:SetWaitMode( self.waitModes.IMPORT_STEAM )
	self:ShowSteamImportRequestBox()	

end


--
function UI.LoginWnd:MasterServer_OnArcNotAttached()

	if not self:IsOnScreen() then
		return
	end

	if self.waitMode ~= self.waitModes.CONNECTING and self.waitMode ~= self.waitModes.CONNECTING_HANG then
		sys.log( "UI.LoginWnd:MasterServer_OnArcNotAttached()[ERROR]: unfit mode: %s", tostring( self.waitMode ) )
		return
	end

	self:SetWaitMode( self.waitModes.IMPORT_ARC )
	self:ShowArcImportRequestBox()	

	local url = "http://star-conflict.com/play"
	if not _G.Arc_NavigateToURL( url ) then
		_G.ShellExecute( url )
	end

end


--
function UI.LoginWnd:OnEditMissMouse( editWnd )

	self:ResetFocus()

end


--
function UI.LoginWnd:MasterServer_OnReconnectAttempt()

	if not self:IsOnScreen() then
		sys.log( "UI.LoginWnd:UI:MasterServer_OnReconnectAttempt()[ERROR]: not on screen" )
		return
	end

	self.eulaIdx = -1
	self:HideAgreementWnd()

	self:ResetCancelConnectingMsg()

	self.creditsFadeTimer = -1
	UI.CreditsWnd:Hide()

	self.connecting_posInQueue = -1
	self.connecting_timeLeft = 0

	self:SetWaitMode( self.waitModes.CONNECTING )

end


--
function UI.LoginWnd:MasterServer_OnForcedUndock()

	if not self:IsOnScreen() then
		sys.log( "UI.LoginWnd:UI:MasterServer_OnForcedUndock()[ERROR]: not on screen" )
		return
	end

	self.bForceUndock = true

end


--
function UI.LoginWnd:MasterServer_OnUndockSpaceStation( result, requestId )

	if not self:IsOnScreen() then
		return
	end

	if result ~= _G.MasterServer.ZoneInstanceTravelResult.ZITR_OK then

		self.bForceUndock = false
		UI.undockError = result

		self:CheckLoadDataComplete()

	end

end


--
function UI.LoginWnd:MasterServer_OnQuests( result, requestId, param1, param2 )

	if not self:IsOnScreen() then
		return
	end

	if requestId == self.questsRequestId then

		self.questsRequestId = 0
		self.questsWaitTimer = -1

		self:CheckLoadDataComplete()

	end

end


--
function UI.LoginWnd:MasterServer_OnAdventures( result, requestId, param1, param2 )

	if not self:IsOnScreen() then
		return
	end

	if requestId == self.adventuresRequestId then

		self.adventuresRequestId = 0
		self.adventuresWaitTimer = -1

		self:CheckLoadDataComplete()

	end

end


--
function UI.LoginWnd:MasterServer_OnWarMapRequest( result, requestId, param1, param2 )

	if not self:IsOnScreen() then
		return
	end
	
	self:OnLoadDataRequest( result, requestId )
	
end


--
function UI.LoginWnd:MasterServer_OnUserNotes( result, requestId, param1, param2, u64Param )

	if not self:IsOnScreen() then
		return
	end
	
	self:OnLoadDataRequest( result, requestId )
	
end


--
function UI.LoginWnd:GameStore_OnStripImproperBattleVessels( result, requestId, param1, param2 )

	if not self:IsOnScreen() then
		return
	end
	
	-- продолжаем даже в с случае, если вернет ошибку;
	-- в этом случае некоторые данные могут оказаться не консистентными или невалидными, но совсем не запрашивать их нельзя, дисконнекта же не произошло;
	-- (месседжбокс с ошибкой показывается в UI:GameStore_OnStripImproperBattleVessels())
	if self.waitMode == self.waitModes.WATIING_DATA_VALIDATION then
		self:LoadData()
	else
		sys.log( "UI.LoginWnd:GameStore_OnStripImproperBattleVessels(): invalid mode %s; expected %d(WATIING_DATA_VALIDATION)", tostring( self.waitMode ), self.waitModes.WATIING_DATA_VALIDATION )
	end

end


-- --------------------------------------
-- const
-- --------------------------------------

lw.layers =
{
    MAIN_EFFECT			= 0,
    BG_EFFECT			= 1,
    BG2_EFFECT			= 2,
    BG3_EFFECT			= 3,
    ACCOUNT_EFFECT		= 4,
    ACCOUNT_LABEL		= 5,
    PASSWORD_EFFECT		= 6,
    PASSWORD_LABEL		= 7,
	BUILD_VERSION		= 8,
	WARNING				= 9,
	SERVER_STATUS		= 10,
	STEAM_LOGIN_TIP		= 11,
	ARC_LOGIN_TIP		= 12,
	PATCH_NAME			= 13,
}

lw.waitModes =
{
	NONE					= 1,
	CONNECTING				= 2,
	WATIING_DATA_VALIDATION	= 3,	-- при коннекте вызывается валидация данных, надо дождаться когда она закончится приходом коллбэка GameStore_OnStripImproperBattleVessels(), и только после этого запрашивать данные
	LOADING					= 4,
	NDA						= 5,
	EULA					= 6,
	EULA_NOT_NEED_ACCEPT	= 7,
	CONNECTING_HANG			= 8,
	CREDITS					= 9,
	IMPORT_STEAM			= 10,
	IMPORT_ARC				= 11,
	IMPORT_STEAM_CONNECTING	= 12,
	IMPORT_ARC_CONNECTING	= 13,
	TWO_STEP_AUTHORISATION	= 14,
}

lw.defaultServers =
{
	-- SC Community Server Preset v0.6.5
	{ name = "Star Conflict Europe - Unofficial Server", address = "57.131.200.242:3801" },
}

lw.sounds =
{
	print			= UI.sounds.print,
	btnMouseOver    = UI.sounds.btnMouseOver,
	btnClick		= UI.sounds.btnClick,
	checkBox		= UI.sounds.checkBox,
	eulaShow		= "sound/ui/btnClick",
	showOptions		= "sound/ui/btnClick",
	showCredits		= UI.sounds.showScreen,
}

lw.SERVER_STATUS_REQUEST_TIME = 60 * 2

lw.DEFAULT_SERVER_PORT = "3801"

lw.effectInfo =
{
	main =
	{
		forgetBtnLocator		= "forgot",
		registerBtnLocator		= "registr",
		rememberCheckBoxLocator	= "remember",
		logInBtnLocator			= "enter",
		steamLogInBtnLocator	= "enter_2",
		arcLogInBtnLocator		= "enter_2",
	},

	account =
	{
		animIdle		= "idle",
		animInactive	= "disable",
		editWndLocator	= "login_input",
	},

	password =
	{
		animIdle		= "idle",
		animInactive	= "disable",
		editWndLocator	= "login_input",
	}
}

lw.loginStatuses =
{
	OK						= 1,
	INPUT_BLOCKED			= 2,
	EMPTY_ACCOUNT			= 3,
	EMPTY_PASSWORD			= 4,	
}

lw.FADE_TIME_TO_BLACK	= 0.5
lw.FADE_TIME_TO_NONE	= 0.5

lw.QUESTS_WAIT_TIME		= 3
lw.ADVENTURES_WAIT_TIME	= 3

-- --------------------------------------
-- vars
-- --------------------------------------

lw.hMsgQuit					= UI.INVALID_UI_HANDLE
lw.hMsgLoadDataFail			= UI.INVALID_UI_HANDLE
lw.hMsgServerStatusError	= UI.INVALID_UI_HANDLE
lw.hMsgCancelConnecting		= UI.INVALID_UI_HANDLE
lw.waitingWnd				= nil
lw.waitMode					= lw.waitModes.NONE
lw.loadingRequestIds		= {}
lw.questsRequestId			= 0
lw.adventuresRequestId		= 0
lw.adventuresWaitTimer		= -1
lw.bWaitingStore			= false
lw.eulaIdx					= -1
lw.serverVersion			= nil
lw.serverStatus				= nil
lw.serverStatusTimer		= -1
lw.news						= {}
lw.servers					= lw.defaultServers
lw.bWaitServers				= false
lw.warningMetaText			= UI.MetaText.GetNewInstance()
lw.connecting_posInQueue	= -1
lw.connecting_timeLeft		= 0
lw.creditsFadeTimer			= -1
lw.hMsgSteamWrongVersion	= UI.INVALID_UI_HANDLE
lw.bForceUndock				= false
lw.questsWaitTimer			= -1
lw.profileRequestId 		= 0
lw.profileTitlesRequestId	= 0
lw.profileAvatarsRequestId	= 0
lw.profileMottosRequestId	= 0
lw.profileAtlasRequestId	= 0

-- --------------------------------------
-- work functions
-- --------------------------------------

--
function UI.LoginWnd:F_PostLoad()

	UI.FullScreenSelectionWnd.F_PostLoad( self )

	self.waitingWnd	= self:GetChildByName( "waitingWnd" )

	self.warningMetaText:InitFromLayer( self, self.layers.WARNING ) 

	local handle = self:GetUiHandle()
	UI:SubscribeUiObjOnEvent( handle, UI.EV_EDIT_CHANGE )
	UI:SubscribeUiObjOnEvent( handle, UI.EV_MSGBOX_RET )
	UI:SubscribeUiObjOnEvent( handle, UI.EV_MASTER_SERVER_DISCONNECTED_SYNC )
	UI:SubscribeUiObjOnEvent( handle, UI.EV_MASTER_SERVER_CONNECTED )	
	UI:SubscribeUiObjOnEvent( handle, UI.EV_COMBO_SELECT_RECORD )	
	UI:SubscribeUiObjOnEvent( handle, UI.EV_WND_HIDED )

end


--
function UI.LoginWnd:F_Shutdown()

	self.warningMetaText:Clear()

	UI.Wnd.F_Shutdown( self )

end


--
function UI.LoginWnd:Reset()

	self.servers = self.defaultServers
	self.bWaitServers = false
	UI.Login_ServersComboBox:Reset()
	UI.Login_ServersComboBox:UnlinkFromParent()
	UI.Login_ServerNameEditWnd:SetEditText( "" )
	UI.Login_ServerNameEditWnd:UnlinkFromParent()
	UI.Login_ServerPortEditWnd:SetEditText( self.DEFAULT_SERVER_PORT )
	UI.Login_ServerPortEditWnd:UnlinkFromParent()

	self.waitMode = self.waitModes.NONE
	self:HideWaitEffect()

	self.loadingRequestIds			= {}
	self.questsRequestId			= 0
	self.profileRequestId			= 0
	self.profileTitlesRequestId		= 0
	self.profileAvatarsRequestId	= 0
	self.profileMottosRequestId		= 0
	self.profileAtlasRequestId		= 0
	self.bWaitingStore				= false
	self.questsWaitTimer			= -1
	self.adventuresRequestId		= 0
	self.adventuresWaitTimer		= -1

	self.eulaIdx = -1
	self:HideAgreementWnd()

	self.warningMetaText:SetText( "", true )
	self.serverVersion		= nil
	self.serverStatus		= nil
	self.serverStatusTimer	= -1
	self:UpdateServerStatusText()

	self:HideNewsWnd()

	self:ResetAuthorizationControls()

	self:UpdateLogInBtn()

	self.connecting_posInQueue	= -1
	self.connecting_timeLeft	= 0

	self:ResetCancelConnectingMsg()

	self.creditsFadeTimer = -1
	UI.CreditsWnd:Hide()

	self:ResetSteamImportAccountControls()
	self:ResetArcImportAccountControls()
	self:HideTwoStepAuthorisationWnd()

	self.bForceUndock = false

end


--
function UI.LoginWnd:FullUpdate()

	self:Reset()

	if UI.store.LoginWnd then
		self:RestoreUiState()

	else
    	self:CheckShowEula()
    	
    	local verType = cvars.cl_versionType
    	if verType == "live" or verType == "test" or verType == "pubtest" or verType == "devtest" then
    		self:RequestServerStatus()
    	end

    	self:RequestNews()
		self:RequestServersList()

		self:UpdateServersComboBox()
		self:UpdateAuthorizationControls()

	end

	self:UpdateBuildVersion()
	self:UpdateWarningText()
	self:UpdateServerStatusText()
	self:UpdateLogInBtn()
	self:UpdateFocus()

end


--
function UI.LoginWnd:UpdateOnSelServerChanged()

	self:UpdateBuildVersion()

	local verType = cvars.cl_versionType
	if verType == "live" or verType == "test" or verType == "pubtest" or verType == "devtest" then

		self:RequestServerStatus()

	else

    	self.serverStatus = nil
    	self.serverVersion = nil

    	self:UpdateWarningText()
    	self:UpdateServerStatusText()

	end

    self:RequestNews()

end


--
function UI.LoginWnd:UpdateServersComboBox()

	if not self:NeedServersComboBox() then
		UI.Login_ServersComboBox:UnlinkFromParent()
		self:UpdateServerAddressWnd()
		return
	end

	self:AddChild( UI.Login_ServersComboBox )

	UI.Login_ServersComboBox:Reset()
	local selRecordIdx = 1
	local configAddress = cvars.net_masterServerAddress

	for idx = 1, #self.servers do

		local serverInfo = self.servers[ idx ]

		local data = {}
		data.address	= serverInfo.address
		data.text		= serverInfo.name
	
		UI.Login_ServersComboBox:AddRecord( data )

		if configAddress ~= "" then
			if serverInfo.address == configAddress then
				selRecordIdx = idx

			elseif serverInfo.name == "server" and configAddress ~= "localhost" then
				selRecordIdx = idx

				local address = configAddress
				local port = self.DEFAULT_SERVER_PORT
				local delimiterPos = string.find( configAddress, ":" )
				if delimiterPos then
					address = string.sub( configAddress, 1, delimiterPos - 1 )
					port = string.sub( configAddress, delimiterPos + 1 )
				end

				UI.Login_ServerNameEditWnd:SetEditText( address )
				UI.Login_ServerPortEditWnd:SetEditText( port )
			end
		end

	end

	UI.Login_ServersComboBox:SelectRecord( selRecordIdx )
	self:UpdateServerAddressWnd()

end


--
function UI.LoginWnd:NeedServersComboBox()

	-- The launcher supplies the single community server address. Keeping the
	-- selector hidden removes the duplicated server name from the login screen.
	return false

end


--
function UI.LoginWnd:F_OnMouseLButtonDown( mouseX, mouseY, wndThatReceivedInput )

	if self:OnMouseLButtonDown( mouseX, mouseY, wndThatReceivedInput ) then
		return true
	end

	local wnd = UI:GetUiObjByHandleT( wndThatReceivedInput )

	if wnd == UI.Login_Connecting_CancelBtn then
		self:LogOut()	

	elseif wnd == UI.Login_LogInBtn then
		self:OnLogIn()

	elseif wnd == UI.Login_SteamLogInBtn then
		self:OnLogIn()

	elseif wnd == UI.Login_ArcLogInBtn then
		self:OnLogIn()

	elseif wnd == UI.Login_ForgetBtn then
		self:OnForgot()

	elseif wnd == UI.Login_SteamImportAccount_ForgetBtn then
		self:OnForgot()

	elseif wnd == UI.Login_ArcImportAccount_ForgetBtn then
		self:OnForgot()

	elseif wnd == UI.Login_RegisterBtn then
		self:OnRegister()

	elseif wnd == UI.Login_SteamImportAccount_RegisterBtn then
		self:OnRegister()

	elseif wnd == UI.Login_ArcImportAccount_RegisterBtn then
		self:OnRegister()

	elseif wnd == UI.Login_QuitBtn then
		self:OnQuit()

	elseif wnd == UI.Login_RememberCheckBox then
		self:OnRememberAccount()

	elseif wnd == UI.Login_OptionsBtn then
		self:OnOptions()

	elseif wnd == UI.Login_LicenseBtn then
		self:OnLicense()

	elseif wnd == UI.Login_CreditsBtn then
		self:OnCredits()

	elseif wnd == UI.Login_SiteBtn then
		self:OnSite()

	--[[elseif wnd == UI.Login_SupportBtn then
		self:OnSupport()]]

	elseif wnd == UI.Login_StartServerBtn then
		self:OnStartServer()

	elseif wnd == UI.Login_SteamImportAccount_ImportBtn then
		self:ImportSteamAccount()

	elseif wnd == UI.Login_ArcImportAccount_ImportBtn then
		self:ImportArcAccount()

	elseif wnd == UI.Login_SteamImportAccount_CancelBtn then
		self:CancelSteamImport()

	elseif wnd == UI.Login_ArcImportAccount_CancelBtn then
		self:CancelArcImport()

	elseif wnd == UI.Login_SteamImportAccountBox_ImportBtn then
		self:ShowSteamImportRequestWnd()

	elseif wnd == UI.Login_ArcImportAccountBox_ImportBtn then
		self:ShowArcImportRequestWnd()

	elseif wnd == UI.Login_SteamImportAccountBox_CreateBtn then
		self:CreateSteamUnattachedAccount()

	elseif wnd == UI.Login_SteamImportAccountBox_CancelBtn then
		self:CancelSteamImport()

	elseif wnd == UI.Login_ArcImportAccountBox_CancelBtn then
		self:CancelArcImport()

	elseif wnd == UI.Login_TwoStepAuthorisation_OkBtn then
		self:OnLogIn()

	elseif wnd == UI.Login_TwoStepAuthorisation_CancelBtn then
		self:StopWaiting()
		
	elseif wnd == UI.Login_PrivacyPolicyBtn then
		self:OnPrivacyPolicy()
		
	elseif wnd == UI.Login_TermsOfUseBtn then
		self:OnLogin_TermsOfUseBtn()
	end

	return true

end


--
function UI.LoginWnd:OnLogIn()

	if not( self.waitMode == self.waitModes.NONE or self.waitMode == self.waitModes.TWO_STEP_AUTHORISATION ) then
		sys.log( "UI.LoginWnd:OnLogIn()[ERROR]: invalid mode: %s", tostring( self.waitMode ) )
		return
	end

	local twoStepCode = ""

	if self.waitMode == self.waitModes.TWO_STEP_AUTHORISATION then
		twoStepCode = UI.Login_TwoStepAuthorisation_KeyEditWnd:GetEditText()
	end

	self:SetWaitMode( self.waitModes.CONNECTING )

	self.connecting_posInQueue = -1
	self.connecting_timeLeft = 0

	self:ValidateConfigAddress()

	local result = true

	if self:IsUsingSteamAccount() then
		result = _G.MasterServer_ClientConnect( "", "", _G.MasterServer.AuthMethod.AM_STEAM, twoStepCode )

	elseif self:IsUsingArcAccount() then
		result = _G.MasterServer_ClientConnect( "", "", _G.MasterServer.AuthMethod.AM_ARC, twoStepCode )

	else
		result = _G.MasterServer_ClientConnect( UI.Login_AccountEditWnd:GetEditText(), UI.Login_PasswordEditWnd:GetEditText(), _G.MasterServer.AuthMethod.AM_INTERNAL, twoStepCode )
	end

	if not result then
		self:StopWaiting()
		UI:MessageBox( UI:GetStringByName( "msgCapt_error" ), UI:GetStringByName( "msg_masterServerFailConnect" ), UI.MBS_OK )
	else
		if self:NeedServersComboBox() then
			UI.SaleAdvert:Init()
		end
	end
	
end


--
function UI.LoginWnd:OnForgot()

	local language = UI:GetLanguage()
	local langDesc = _G.locale and _G.locale.languages and _G.locale.languages[ language ]

	local link = langDesc and langDesc.restorePasswordLink

	if link then
		_G.ShellExecute( link )
	else
		sys.log( "UI.LoginWnd:OnForgot()[ERROR]: cannot find _G.locale.languages[%s].restorePasswordLink", language )
	end

end


--
function UI.LoginWnd:OnRegister()

	local language = UI:GetLanguage()
	local langDesc = _G.locale and _G.locale.languages and _G.locale.languages[ language ]
	local fieldName = self:IsSteamAccount() and "registerLinkSteam" or "registerLink"

	local link = langDesc and langDesc[ fieldName ]

	if not link then
		local defaultLangDesc = _G.locale and _G.locale.languages and _G.locale.languages.ENGLISH
		link = defaultLangDesc and defaultLangDesc[ fieldName ]
	end

	if link then
		if self:IsSteamAccount() then
			_G.Steam_NavigateToURL( link )
		else
			_G.ShellExecute( link )
		end
	else
		sys.log( "UI.LoginWnd:OnRegister()[ERROR]: cannot find _G.locale.languages[%s].%s", language, fieldName )
	end

end


--
function UI.LoginWnd:OnQuit()

	self.hMsgQuit = UI:MessageBox( UI:GetStringByName( "msgCapt_actionConfirm" ), UI:GetStringByName( "msg_exitApp" ), UI.MBS_YES_NO )

end


--
function UI.LoginWnd:OnRememberAccount()
	
	UI.Login_RememberCheckBox:ToggleCheck()

	if UI.Login_RememberCheckBox:IsChecked() then
		self:SaveAuthorizationData()
	else
		self:ClearSavedAuthorizationData()
	end

end


--
function UI.LoginWnd:OnOptions()

	UI.OptionsWnd:Setup( UI.OptionsWnd.modes.LOGIN, {} )
	UI.OptionsWnd:Show( false )

	UI:PlayGlobalSound( self.sounds.showOptions )

end


--
function UI.LoginWnd:OnLicense()

	if self.waitMode ~= self.waitModes.NONE then
		sys.log( "UI.LoginWnd:OnLicense()[ERROR]: invalid mode: %s", tostring( self.waitMode ) )
		return
	end

	if not _G.EULA or type( _G.EULA ) ~= "table" or not next( _G.EULA ) then
		sys.log( "UI.LoginWnd:OnLicense()[WARNING]: cannot find \"EULA\" table or the table is empty" )
		return
	end

	self:SetWaitMode( self.waitModes.EULA_NOT_NEED_ACCEPT )
	self:SetEulaIdx( 1, false )

end


--
function UI.LoginWnd:OnCredits()

	if self.waitMode ~= self.waitModes.NONE then
		sys.log( "UI.LoginWnd:OnCredits()[ERROR]: invalid mode: %s", tostring( self.waitMode ) )
		return
	end

	self.creditsFadeTimer = self.FADE_TIME_TO_BLACK
	self:SetWaitMode( self.waitModes.CREDITS )

	UI:PlayGlobalSound( self.sounds.showCredits )

	cvars.fadeOutColor = 0xff000000
	sys.concmd( string.format( "cl_fadeout %f", self.FADE_TIME_TO_BLACK ) )

end


--
function UI.LoginWnd:DoShowCredits()

	self.creditsFadeTimer = -1

	cvars.fadeInColor = 0x00000000
	sys.concmd( string.format( "cl_fadein %f", self.FADE_TIME_TO_NONE ) )

	UI.CreditsWnd:Show()

end


--
function UI.LoginWnd:OnSite()

	_G.ShellExecute( "https://star-conflict-eu-server.mak17.workers.dev" )

end


--
function UI.LoginWnd:OnSupport()

	local lang = UI:GetLanguage()
	local langDesc = _G.locale and _G.locale.languages and _G.locale.languages[ lang ]

	local link = langDesc and langDesc.supportLink
	if UI:IsStrEmpty( link ) then

		local engDesc = _G.locale and _G.locale.languages and _G.locale.languages.ENGLISH
		link = engDesc and engDesc.supportLink

	end

	if not UI:IsStrEmpty( link ) then
		_G.ShellExecute( link )
	else
		sys.log( "UI.LoginWnd:OnSupport()[ERROR]: cannot find _G.locale.languages[%s].supportLink", lang )
	end	

end


function UI.LoginWnd:OnStartServer()
	_G.ShellExecute( "https://discord.gg/83YkbJbwxx" )
end


--
function UI.LoginWnd:OnPrivacyPolicy()
	
	local lang = UI:GetLanguage()
	local langDesc = _G.locale and _G.locale.languages and _G.locale.languages[ lang ]

	local link = langDesc and langDesc.privacyPolicyLink
	if UI:IsStrEmpty( link ) then

		local engDesc = _G.locale and _G.locale.languages and _G.locale.languages.ENGLISH
		link = engDesc and engDesc.privacyPolicyLink

	end

	if not UI:IsStrEmpty( link ) then
		_G.ShellExecute( link )
	else
		sys.log( "UI.LoginWnd:OnPrivacyPolicy()[ERROR]: cannot find _G.locale.languages[%s].privacyPolicyLink", lang )
	end	

end


--
function UI.LoginWnd:OnLogin_TermsOfUseBtn()
	
	local lang = UI:GetLanguage()
	local langDesc = _G.locale and _G.locale.languages and _G.locale.languages[ lang ]

	local link = langDesc and langDesc.termsOfUseLink
	if UI:IsStrEmpty( link ) then

		local engDesc = _G.locale and _G.locale.languages and _G.locale.languages.ENGLISH
		link = engDesc and engDesc.termsOfUseLink

	end

	if not UI:IsStrEmpty( link ) then
		_G.ShellExecute( link )
	else
		sys.log( "UI.LoginWnd:OnLogin_TermsOfUseBtn()[ERROR]: cannot find _G.locale.languages[%s].termsOfUseLink", lang )
	end	

end


--
function UI.LoginWnd:UpdateLogInBtn()

	local bEnable = self:GetLoginStatus() == self.loginStatuses.OK

	if self:IsUsingSteamAccount() then
		UI.Login_SteamLogInBtn:Enable( bEnable )

	elseif self:IsUsingArcAccount() then
		UI.Login_ArcLogInBtn:Enable( bEnable )

	else
		UI.Login_LogInBtn:Enable( bEnable )
	end

end


--
function UI.LoginWnd:GetLoginStatus()

	if self.waitMode ~= self.waitModes.NONE then
		return self.loginStatuses.INPUT_BLOCKED
	end

	if not self:IsUsingSteamAccount() and not self:IsUsingArcAccount() then

    	if UI:IsStrEmpty( UI.Login_AccountEditWnd:GetEditText() ) then
			return self.loginStatuses.EMPTY_ACCOUNT
    	end

    	if UI:IsStrEmpty( UI.Login_PasswordEditWnd:GetEditText() ) then
			return self.loginStatuses.EMPTY_PASSWORD
    	end

	end

	return self.loginStatuses.OK

end


--
function UI.LoginWnd:F_OnEventEditChange( hSender, eventSrc )

	if hSender == UI.Login_ServerNameEditWnd:GetUiHandle() or hSender == UI.Login_ServerPortEditWnd:GetUiHandle() then
		self:UpdateConfigAddressFromServerAddress()
	end

	if not self:IsUsingSteamAccount() and not self:IsUsingArcAccount() then
		self:UpdateLogInBtn()
	end

	if self:IsOnScreen() and eventSrc ~= UI.EVENT_SRC_UNKNOWN then
		UI:PlayGlobalSound( self.sounds.print )
	end

end


--
function UI.LoginWnd:F_OnAfterHideFromScreen()

	if not UI:IsInRemovingAllWindows() then
		UI.FullScreenSelectionWnd.F_OnAfterHideFromScreen( self )
	else
		self:OnAfterHideFromScreen()
	end

	self.hMsgQuit 				= UI.INVALID_UI_HANDLE
	self.hMsgLoadDataFail		= UI.INVALID_UI_HANDLE
	self.hMsgServerStatusError	= UI.INVALID_UI_HANDLE
	self.hMsgSteamWrongVersion	= UI.INVALID_UI_HANDLE

	self:ResetCancelConnectingMsg()
	self:ResetSteamImportAccountControls()
	self:ResetArcImportAccountControls()

	if not UI:IsInShutdown() then
		self:CheckSaveAuthorizationData()
	end

	if self.creditsFadeTimer ~= -1 then
		self.creditsFadeTimer = -1
		cvars.fadeInColor = 0x00000000
		sys.concmd( string.format( "cl_fadein %f", 0 ) )
	end

end


--
function UI.LoginWnd:F_OnAfterShowOnScreen()

	UI.FullScreenSelectionWnd.F_OnAfterShowOnScreen( self )

	self.warningMetaText:UpdateScreenOrgFromLayer( self, self.layers.WARNING )

	if not self:NeedServersComboBox() then
		UI.SaleAdvert:Init()
	end

end


--
function UI.LoginWnd:F_OnEventMsgBoxRet( hSender, retCode, boxHandle )

	if not self:IsOnScreen() then
		return
	end

	if boxHandle == self.hMsgQuit then
		self.hMsgQuit = UI.INVALID_UI_HANDLE

		if retCode == UI.MBRET_YES then
			self:QuitGame()
		end

	elseif boxHandle == self.hMsgLoadDataFail then
		self.hMsgLoadDataFail = UI.INVALID_UI_HANDLE

	elseif boxHandle == self.hMsgServerStatusError then
		self.hMsgServerStatusError = UI.INVALID_UI_HANDLE

	elseif boxHandle == self.hMsgCancelConnecting then
		self.hMsgCancelConnecting = UI.INVALID_UI_HANDLE

		if retCode == UI.MBRET_YES then
    		self:LogOut()
			UI:PlayGlobalSound( UI.sounds.msgBoxClose )
		end	

	elseif boxHandle == self.hMsgSteamWrongVersion then
		self.hMsgSteamWrongVersion = UI.INVALID_UI_HANDLE
		--self:QuitGame()

	end

end


--
function UI.LoginWnd:QuitGame()

	self:CheckSaveAuthorizationData()	-- после зарытия в F_OnHideFromScreen() нельзя обращаться к профилю
    sys.concmd( "quit" )

end


--
function UI.LoginWnd:F_OnEventMasterServerConnected( hSender, iParam0, iParam1, fParam0, fParam1 )

	if not self:IsOnScreen() then
		return
	end

	if not( self.waitMode ~= self.waitModes.CONNECTING or
			self.waitMode ~= self.waitModes.CONNECTING_HANG or
			self.waitMode ~= self.waitModes.IMPORT_STEAM or
			self.waitMode ~= self.waitModes.IMPORT_ARC or
			self.waitMode ~= self.waitModes.IMPORT_STEAM_CONNECTING or
			self.waitMode ~= self.waitModes.IMPORT_ARC_CONNECTING ) then
				return
	end

	self.connecting_posInQueue	= -1
	self.connecting_timeLeft	= 0

	self:ResetCancelConnectingMsg()
	self:ResetSteamImportAccountControls()
	self:ResetArcImportAccountControls()
	
	-- при коннекте вызывается валидация данных, надо дождаться когда она закончится приходом коллбэка GameStore_OnStripImproperBattleVessels(), и только после этого запрашивать данные
	self:SetWaitMode( self.waitModes.WATIING_DATA_VALIDATION )

end


--
function UI.LoginWnd:F_OnEventMasterServerDisconnectedSync( hSender, iParam0, iParam1, fParam0, fParam1 )

	if not self:IsOnScreen() then
		return
	end

	if	self.waitMode == self.waitModes.NONE or
		self.waitMode == self.waitModes.EULA or
		self.waitMode == self.waitModes.EULA_NOT_NEED_ACCEPT or
		self.waitMode == self.waitModes.CREDITS then
			return	
	end	

	self:StopWaiting()
	self:HideAgreementWnd()

	self.connecting_posInQueue	= -1
	self.connecting_timeLeft	= 0

	self:ResetCancelConnectingMsg()
	self:ResetSteamImportAccountControls()
	self:ResetArcImportAccountControls()

	local reason = iParam0

	if reason == _G.network.MasterServerDisconnectReason.DR_YUPLAY_2STEP then
		self:SetWaitMode( self.waitModes.TWO_STEP_AUTHORISATION )
	else
		UI:ShowMsgOnMasterServerConnectionLost( reason )
	end

end


--
function UI.LoginWnd:SetWaitMode( waitMode )

	if UI:Val2Key( self.waitModes, waitMode ) == "" then
		sys.log( "UI.LoginWnd:SetWaitMode()[ERROR]: invalid waitMode: \"%s\"", tostring( waitMode ) )
		return
	end

	self.waitMode = waitMode

	self:UpdateWaitEffect()

	self:UpdateLogInBtn()
	self:UpdateFocus()

end


--
function UI.LoginWnd:StopWaiting()

	self:SetWaitMode( self.waitModes.NONE )

end


--
function UI.LoginWnd:UpdateWaitEffect()

	self:HideWaitEffect()

	if self.waitMode == self.waitModes.CONNECTING_HANG then

		self:AddChild( UI.Login_ConnectingWnd )
		UI.Login_ConnectingWnd:Setup( self.connecting_posInQueue, self.connecting_timeLeft )

	elseif self.waitMode == self.waitModes.CONNECTING
		or self.waitMode == self.waitModes.WATIING_DATA_VALIDATION
		or self.waitMode == self.waitModes.LOADING
		or self.waitMode == self.waitModes.IMPORT_STEAM_CONNECTING
		or self.waitMode == self.waitModes.IMPORT_ARC_CONNECTING then

			self:AddChild( self.waitingWnd )
			self.waitingWnd:SetWaitText( self:GetWaitMsg( self.waitMode ) )

	elseif self.waitMode == self.waitModes.TWO_STEP_AUTHORISATION then
		self:ShowTwoStepAuthorisationWnd()
	end

end


--
function UI.LoginWnd:HideWaitEffect()

	self.waitingWnd:UnlinkFromParent()
	UI.Login_ConnectingWnd:UnlinkFromParent()
	self:HideTwoStepAuthorisationWnd()

end


--
function UI.LoginWnd:GetWaitMsg( waitMode )

	local str = ""

	if waitMode == self.waitModes.CONNECTING then
		str = UI:GetStringForPlatform( "connecting" )

	elseif waitMode == self.waitModes.WATIING_DATA_VALIDATION or waitMode == self.waitModes.LOADING then
		str = UI:GetStringForPlatform( "hangar_loading" )

	elseif waitMode == self.waitModes.IMPORT_STEAM_CONNECTING then
		str = UI:GetStringForPlatform( "connecting" )

	elseif waitMode == self.waitModes.IMPORT_ARC_CONNECTING then
		str = UI:GetStringForPlatform( "connecting" )

	end

	return str

end


--
function UI.LoginWnd:SaveAuthorizationData()

	local profile = _G.GetProfileTable()

	local acc	= UI.Login_AccountEditWnd:GetEditText()
	local pass	= UI.Login_PasswordEditWnd:GetEditText()

	if acc ~= profile.lastAccount or pass ~= profile.lastPassword then
		profile.lastAccount = acc
		profile.lastPassword = pass
		Profile:Save()
	end

end


--
function UI.LoginWnd:ClearSavedAuthorizationData()

	local profile = _G.GetProfileTable()

	if profile.lastAccount or profile.lastPassword then
		profile.lastAccount = nil
		profile.lastPassword = nil
		Profile:Save()
	end

end


--
function UI.LoginWnd:RestoreSavedAuthorizationData()

	local profile = _G.GetProfileTable()

	if profile.lastAccount or profile.lastPassword then

		UI.Login_AccountEditWnd:SetEditText( profile.lastAccount or "" )
		UI.Login_PasswordEditWnd:SetEditText( profile.lastPassword or "" )

		UI.Login_RememberCheckBox:Check( true )

	end

end


--
function UI.LoginWnd:CheckSaveAuthorizationData()

	if not self:IsUsingSteamAccount() and not self:IsUsingArcAccount() and UI.Login_RememberCheckBox:IsChecked() then
		self:SaveAuthorizationData()
	end

end


--
function UI.LoginWnd:F_OnEventSaveUiState()

	if not self:IsOnScreen() then
		return
	end

	UI.store.LoginWnd =
	{
		account						= UI.Login_AccountEditWnd:GetEditText(),
		password					= UI.Login_PasswordEditWnd:GetEditText(),
		bRememberAccount			= UI.Login_RememberCheckBox:IsChecked(),
		waitMode					= self.waitMode,
		loadingRequestIds			= self.loadingRequestIds,
		questsRequestId				= self.questsRequestId,
		profileRequestId			= self.profileRequestId,
		profileTitlesRequestId		= self.profileTitlesRequestId,
		profileAvatarsRequestId		= self.profileAvatarsRequestId,
		profileMottosRequestId		= self.profileMottosRequestId,
		profileAtlasRequestId		= self.profileAtlasRequestId,
		bWaitingStore				= self.bWaitingStore,
		questsWaitTimer				= self.questsWaitTimer,
		adventuresRequestId			= self.adventuresRequestId,
		adventuresWaitTimer			= self.adventuresWaitTimer,
		eulaIdx						= self.eulaIdx,
		serverVersion				= self.serverVersion,
		serverStatus				= self.serverStatus,
		serverStatusTimer			= self.serverStatusTimer,
		news						= self.news,
		servers						= self.servers,
		bWaitServers				= self.bWaitServers,
		selServerIdx				= UI.Login_ServersComboBox:GetSelectedRecord(),
		serverName					= UI.Login_ServerNameEditWnd:GetEditText(),
		serverPort					= UI.Login_ServerPortEditWnd:GetEditText(),
		connecting_posInQueue		= self.connecting_posInQueue,
		connecting_timeLeft			= self.connecting_timeLeft,
		bSteamImportRequestBox		= UI.Login_SteamImportAccountBox:IsOnScreen(),
		bSteamImportRequestWnd		= UI.Login_SteamImportAccountWnd:IsChildOf( self ),
		steamImportAccount			= UI.Login_SteamImportAccount_AccountEditWnd:GetEditText(),
		steamImportPassword			= UI.Login_SteamImportAccount_PasswordEditWnd:GetEditText(),
		bArcImportRequestBox		= UI.Login_ArcImportAccountBox:IsOnScreen(),
		bArcImportRequestWnd		= UI.Login_ArcImportAccountWnd:IsChildOf( self ),
		arcImportAccount			= UI.Login_ArcImportAccount_AccountEditWnd:GetEditText(),
		arcImportPassword			= UI.Login_ArcImportAccount_PasswordEditWnd:GetEditText(),
		bForceUndock				= self.bForceUndock,
		twoStepAuthorisationKey		= UI.Login_TwoStepAuthorisationWnd:IsChildOf( self ) and UI.Login_TwoStepAuthorisation_KeyEditWnd:GetEditText() or "",
	}

end


--
function UI.LoginWnd:F_OnEventRestoreUiState()

	if self:IsOnScreen() then
		self:RestoreUiState()
	end
	
end


--
function UI.LoginWnd:RestoreUiState()

	if not UI.store.LoginWnd then
		return
	end

	self.bForceUndock = UI.store.LoginWnd.bForceUndock

	self:UpdateAuthorizationControls()

	if self:IsUsingSteamAccount() then

    	if UI.store.LoginWnd.bSteamImportRequestBox then
    		self:ShowSteamImportRequestBox()

    	elseif UI.store.LoginWnd.bSteamImportRequestWnd then
    		self:ShowSteamImportRequestWnd()
    		UI.Login_SteamImportAccount_AccountEditWnd:SetEditText( UI.store.LoginWnd.steamImportAccount )
    		UI.Login_SteamImportAccount_PasswordEditWnd:SetEditText( UI.store.LoginWnd.steamImportPassword )
		end

	elseif self:IsUsingArcAccount() then

    	if UI.store.LoginWnd.bArcImportRequestBox then
    		self:ShowArcImportRequestBox()

    	elseif UI.store.LoginWnd.bArcImportRequestWnd then
    		self:ShowArcImportRequestWnd()
    		UI.Login_ArcImportAccount_AccountEditWnd:SetEditText( UI.store.LoginWnd.arcImportAccount )
    		UI.Login_ArcImportAccount_PasswordEditWnd:SetEditText( UI.store.LoginWnd.arcImportPassword )
		end

	else
		UI.Login_AccountEditWnd:SetEditText( UI.store.LoginWnd.account )
		UI.Login_PasswordEditWnd:SetEditText( UI.store.LoginWnd.password )
		UI.Login_RememberCheckBox:Check( UI.store.LoginWnd.bRememberAccount )
	end

	self.eulaIdx			= UI.store.LoginWnd.eulaIdx

	self.loadingRequestIds			= UI.store.LoginWnd.loadingRequestIds
	self.questsRequestId			= UI.store.LoginWnd.questsRequestId
	self.profileRequestId			= UI.store.LoginWnd.profileRequestId
	self.profileTitlesRequestId		= UI.store.LoginWnd.profileTitlesRequestId
	self.profileAvatarsRequestId	= UI.store.LoginWnd.profileAvatarsRequestId
	self.profileMottosRequestId		= UI.store.LoginWnd.profileMottosRequestId
	self.profileAtlasRequestId		= UI.store.LoginWnd.profileAtlasRequestId
	self.bWaitingStore				= UI.store.LoginWnd.bWaitingStore
	self.questsWaitTimer			= UI.store.LoginWnd.questsWaitTimer
	self.adventuresRequestId		= UI.store.LoginWnd.adventuresRequestId
	self.adventuresWaitTimer		= UI.store.LoginWnd.adventuresWaitTimer

	self.news = UI.store.LoginWnd.news
	if self.news and next( self.news ) then
		UI.NewsWnd:Setup( self.news )
		self:ShowNewsWnd()
	end

	self.serverVersion		= UI.store.LoginWnd.serverVersion
	self.serverStatus		= UI.store.LoginWnd.serverStatus
	self.serverStatusTimer	= UI.store.LoginWnd.serverStatusTimer

	self.servers		= UI.store.LoginWnd.servers
	self.bWaitServers	= UI.store.LoginWnd.bWaitServers
	self:UpdateServersComboBox()
	UI.Login_ServerNameEditWnd:SetEditText( UI.store.LoginWnd.serverName or "" )
	UI.Login_ServerPortEditWnd:SetEditText( UI.store.LoginWnd.serverPort or self.DEFAULT_SERVER_PORT )
	UI.Login_ServersComboBox:SelectRecord( UI.store.LoginWnd.selServerIdx )
	self:UpdateServerAddressWnd()

	self.connecting_posInQueue	= UI.store.LoginWnd.connecting_posInQueue
	self.connecting_timeLeft	= UI.store.LoginWnd.connecting_timeLeft

	self:SetWaitMode( UI.store.LoginWnd.waitMode )

	if self.waitMode == self.waitModes.CREDITS and not UI.CreditsWnd:IsOnScreen() then
		UI.CreditsWnd:Show()		

	elseif self.waitMode == self.waitModes.TWO_STEP_AUTHORISATION then
		UI.Login_TwoStepAuthorisation_KeyEditWnd:SetEditText( UI.store.LoginWnd.twoStepAuthorisationKey )
	end

	UI.store.LoginWnd = nil

end


--
function UI.LoginWnd:LoadData()

	self:SetWaitMode( self.waitModes.LOADING )
	
	UI:ShipPreset_ReadFromFile()

	self.bWaitingStore = true
	_G.GameStore_ForceReload()

	self.loadingRequestIds			= {}
	self.questsRequestId			= 0
	self.profileRequestId			= 0
	self.profileTitlesRequestId		= 0
	self.profileAvatarsRequestId	= 0
	self.profileMottosRequestId		= 0
	self.profileAtlasRequestId		= 0
	self.questsWaitTimer			= -1
	self.adventuresRequestId		= 0
	self.adventuresWaitTimer		= -1

	if not self:AddRequest( _G.MasterServer_LoadInitialPlayerData() ) then
		return
	end

	if not self:AddRequest( _G.MasterServer_ClanRequestDesc() ) then
		return
	end

	if not self:AddRequest( _G.MasterServer_RequestLobby() ) then
		return
	end

	--[[local achieveRequestId = UI.Profile:RequestAchievements( _G.MasterServer_GetLocalUserId() )
	if achieveRequestId ~= nil then
		if not self:AddRequest( achieveRequestId ) then
			return
		end
	end]]

	if not self:AddRequest( _G.MasterServer_RequestSocial() ) then
		return
	end

	if not self:AddRequest( _G.MasterServer_MailRequest() ) then
		return
	end

	if not self:AddRequest( _G.MasterServer_LeaderboardRequestDescs() ) then
		return
	end	

	if not self:AddRequest( _G.MasterServer_RequestTeaching() ) then
		return
	end

	if not self:AddRequest( _G.MasterServer_RequestSquadInfo() ) then
		return
	end

	if not self:AddRequest( _G.MasterServer_RequestLeagueTeamInfo() ) then
		return
	end
	
	local uid = _G.MasterServer_GetLocalUserId()

	self.profileRequestId = _G.MasterServer_UserProfileRequestField( uid, MasterServer.UserProfileField.UPF_GENERAL_STATS )
	if self.profileRequestId == 0 then
		self:OnLoadDataFail( UI:GetStringByName( "msg_requestDataError" ) )
		return
	end

	self.profileTitlesRequestId = _G.MasterServer_UserProfileRequestField( uid, MasterServer.UserProfileField.UPF_TITLES )
	if self.profileTitlesRequestId == 0 then
		self:OnLoadDataFail( UI:GetStringByName( "msg_requestDataError" ) )
		return
	end
	
	self.profileAvatarsRequestId = _G.MasterServer_UserProfileRequestField( uid, MasterServer.UserProfileField.UPF_AVATARS )
	if self.profileAvatarsRequestId == 0 then
		self:OnLoadDataFail( UI:GetStringByName( "msg_requestDataError" ) )
		return
	end
	
	self.profileMottosRequestId = _G.MasterServer_UserProfileRequestField( uid, MasterServer.UserProfileField.UPF_MOTTOS )
	if self.profileMottosRequestId == 0 then
		self:OnLoadDataFail( UI:GetStringByName( "msg_requestDataError" ) )
		return
	end

	self.profileAtlasRequestId = _G.MasterServer_UserProfileRequestField( uid, MasterServer.UserProfileField.UPF_ATLAS )
	if self.profileAtlasRequestId == 0 then
		self:OnLoadDataFail( UI:GetStringByName( "msg_requestDataError" ) )
		return
	end

	self.questsRequestId = _G.MasterServer_RequestQuests()
	if self.questsRequestId ~= 0 then
		self.questsWaitTimer = self.QUESTS_WAIT_TIME
	else
		self:OnLoadDataFail( UI:GetStringByName( "msg_requestDataError" ) )
		return
	end
	
	self.adventuresRequestId = _G.MasterServer_RequestAdventures()
	if self.adventuresRequestId ~= 0 then
		self.adventuresWaitTimer = self.ADVENTURES_WAIT_TIME
	else
		self:OnLoadDataFail( UI:GetStringByName( "msg_requestDataError" ) )
		return
	end
	
	-- не ругаемся, если userNotesRequestId=0, т.к. это просто означает, что заметки не запрашиваются с сервера, а загрузились из локального файла
	local userNotesRequestId = _G.MasterServer_RequestUserNotes()
	if userNotesRequestId ~= 0 then
		self.loadingRequestIds[ userNotesRequestId ] = true
	end

end


--
function UI.LoginWnd:AddRequest( requestId )

	if requestId ~= 0 then
		self.loadingRequestIds[ requestId ] = true
		return true

	else
		self:OnLoadDataFail( UI:GetStringByName( "msg_requestDataError" ) )
		return false
	end

end


--
function UI.LoginWnd:OnLoadDataFail( errorMsg )

	if self.waitMode ~= self.waitModes.LOADING then
		sys.log( "UI.LoginWnd:OnLoadDataFail()[ERROR]: not in LOADING mode" )
		return
	end

	self:LogOut()

	if self.hMsgLoadDataFail == UI.INVALID_UI_HANDLE then
		self.hMsgLoadDataFail = UI:MessageBox( UI:GetStringByName( "msgCapt_error" ), errorMsg, UI.MBS_OK )
	end

end


--
function UI.LoginWnd:LogOut()

	self:StopWaiting()

	self.bWaitingStore				= false
	self.loadingRequestIds			= {}
	self.questsRequestId			= 0
	self.profileRequestId			= 0
	self.profileTitlesRequestId		= 0
	self.profileAvatarsRequestId	= 0
	self.profileMottosRequestId		= 0
	self.questsWaitTimer			= -1
	self.connecting_posInQueue		= -1
	self.connecting_timeLeft		= 0
	self.adventuresRequestId		= 0
	self.adventuresWaitTimer		= -1

	self:ResetCancelConnectingMsg()
	self:ResetSteamImportAccountControls()
	self:ResetArcImportAccountControls()

	_G.MasterServer_ClientDisconnect()

end


--
function UI.LoginWnd:CheckLoadDataComplete()

	if self.waitMode ~= self.waitModes.LOADING then
		return
	end

	if self.bWaitingStore then
		return
	end

	if next( self.loadingRequestIds ) then
		return
	end

	if self.questsRequestId ~= 0 then
		return
	end
	
	if self.adventuresRequestId ~= 0 then
		return
	end

	if self.profileRequestId ~= 0 then
		return
	end

	if self.profileTitlesRequestId ~= 0 then
		return
	end
	
	if self.profileAvatarsRequestId ~= 0 then
		return
	end
	
	if self.profileMottosRequestId ~= 0 then
		return
	end
	
	if self.profileAtlasRequestId ~= 0 then
		return
	end

	self:OnLoadDataComplete()

end


--
function UI.LoginWnd:OnLoadDataComplete()

	if self.waitMode ~= self.waitModes.LOADING then
		sys.log( "UI.LoginWnd:OnLoadDataComplete()[ERROR]: not in LOADING mode" )
		return
	end
	
	-- FIXME где этот функционал лучше вызывать??
	-- удаляются заметки дли игроков, которые больше не входят в социальные списки локального игрока
	-- (они могли удалится оттуда, когда игрок был в оффлайн)
	-- не ждем ответа на этот запрос, т.к. не критично, если устаревшие заметки побудут пару секунд сохраненными
	_G.MasterServer_DeleteUserNotesIfInvalidRelationship()

	if self.bForceUndock then
		return
	end

	if self:NeedShowNDA() then
		self:SetWaitMode( self.waitModes.NDA )
		self:ShowNDA()
	else
		self:ProceedToHangar()
	end

end


--
function UI.LoginWnd:NeedShowNDA()

	-- #0020343
	if true then
		return false
	end

	if _G.IsAppDevRun() then
		return false
	end

	local prevVersion = UI.serverData.userData.NDA and UI.serverData.userData.NDA.appVersion or ""
	local curVersion = _G.GetAppVersion()

	return prevVersion ~= curVersion

end


--
function UI.LoginWnd:ShowNDA()

	UI:PlayGlobalSound( self.sounds.eulaShow )
	UI.AgreementWnd:SetupForNDA( true )
	UI.AgreementWnd:Show( false )

end


--
function UI.LoginWnd:HideAgreementWnd()

	UI.AgreementWnd:Hide( false )

end


--
function UI.LoginWnd:ProceedToHangar()

	-- UI:LoadMainMenuLevel()
	UI:HideAllWindows()
	UI.AntechamberWnd:Show()

end


--
function UI.LoginWnd:OnLoadDataRequest( result, requestId )

	if self.loadingRequestIds[ requestId ] then

		self.loadingRequestIds[ requestId ] = nil

		if result == 0 then
			self:CheckLoadDataComplete()
		else
			self:OnLoadDataFail( UI:GetStringByName( "msg_timeOut" ) )
		end

	end

end


--
function UI.LoginWnd:OnTab( key, controllerIdx )

	if self.waitMode == self.waitModes.NONE then

    	local hFocus	= UI:GetKeyboardFocus()
    	local hAccound	= UI.Login_AccountEditWnd:GetUiHandle()
    	local hPassword	= UI.Login_PasswordEditWnd:GetUiHandle()

    	if hFocus ~= hAccound and hFocus ~= hPassword then
    		UI:SetKeyboardFocus( hAccound )

    	elseif hFocus == hAccound then
    		UI:SetKeyboardFocus( hPassword )		

    	elseif hFocus == hPassword then
    		UI:SetKeyboardFocus( hAccound )	
    	end

	elseif self.waitMode == self.waitModes.IMPORT_STEAM and UI.Login_SteamImportAccountWnd:IsChildOf( self ) then

    	local hFocus	= UI:GetKeyboardFocus()
    	local hAccound	= UI.Login_SteamImportAccount_AccountEditWnd:GetUiHandle()
    	local hPassword	= UI.Login_SteamImportAccount_PasswordEditWnd:GetUiHandle()

    	if hFocus ~= hAccound and hFocus ~= hPassword then
    		UI:SetKeyboardFocus( hAccound )

    	elseif hFocus == hAccound then
    		UI:SetKeyboardFocus( hPassword )		

    	elseif hFocus == hPassword then
    		UI:SetKeyboardFocus( hAccound )	
    	end

	elseif self.waitMode == self.waitModes.IMPORT_ARC and UI.Login_ArcImportAccountWnd:IsChildOf( self ) then

    	local hFocus	= UI:GetKeyboardFocus()
    	local hAccound	= UI.Login_ArcImportAccount_AccountEditWnd:GetUiHandle()
    	local hPassword	= UI.Login_ArcImportAccount_PasswordEditWnd:GetUiHandle()

    	if hFocus ~= hAccound and hFocus ~= hPassword then
    		UI:SetKeyboardFocus( hAccound )

    	elseif hFocus == hAccound then
    		UI:SetKeyboardFocus( hPassword )		

    	elseif hFocus == hPassword then
    		UI:SetKeyboardFocus( hAccound )	
    	end

	elseif self.waitMode == self.waitModes.TWO_STEP_AUTHORISATION and UI.Login_TwoStepAuthorisationWnd:IsChildOf( self ) then

    	local hFocus	= UI:GetKeyboardFocus()
    	local hKey		= UI.Login_TwoStepAuthorisation_KeyEditWnd:GetUiHandle()

    	if hFocus ~= hKey then
    		UI:SetKeyboardFocus( hKey )
		end

	end

	return true

end


--
function UI.LoginWnd:OnEnter( key, controllerIdx )

	local loginStatus = self:GetLoginStatus()

	if loginStatus == self.loginStatuses.OK then
		self:OnLogIn()		

	elseif loginStatus == self.loginStatuses.INPUT_BLOCKED then

		if self.waitMode == self.waitModes.TWO_STEP_AUTHORISATION and UI.Login_TwoStepAuthorisationWnd:IsChildOf( self ) then
			self:OnLogIn()
		end

	elseif loginStatus == self.loginStatuses.EMPTY_ACCOUNT then
		UI:MessageBox( UI:GetStringByName( "msgCapt_error" ), UI:GetStringByName( "msg_emptyAccount" ), UI.MBS_OK )	

	elseif loginStatus == self.loginStatuses.EMPTY_PASSWORD then
		UI:MessageBox( UI:GetStringByName( "msgCapt_error" ), UI:GetStringByName( "msg_emptyPassword" ), UI.MBS_OK )	

	else
		sys.log( "UI.LoginWnd:OnEnter()[ERROR]: unhandled login status: %s", tostring( loginStatus ) )
	end

	return true

end


--
function UI.LoginWnd:OnEscape( key, controllerIdx )

	if self.waitMode == self.waitModes.CONNECTING and self.hMsgCancelConnecting == UI.INVALID_UI_HANDLE then

		self.hMsgCancelConnecting = UI:MessageBox( UI:GetStringByName( "msgCapt_actionConfirm" ), UI:GetStringByName( "login_cancelConnectingConfirm" ), UI.MBS_YES_NO )

	elseif self.waitMode == self.waitModes.NONE then

    	local hFocus = UI:GetKeyboardFocus()
    	local wndFocus = UI:GetUiObjByHandleT( hFocus )

    	if wndFocus and wndFocus:GetClassName() == "EditWnd" and not UI:IsStrEmpty( wndFocus:GetEditText() ) then
    		wndFocus:SetEditText( "" )
    	else
    		self:OnQuit()
    	end

	elseif self.waitMode == self.waitModes.IMPORT_STEAM and UI.Login_SteamImportAccountWnd:IsChildOf( self ) then

    	local hFocus = UI:GetKeyboardFocus()
    	local wndFocus = UI:GetUiObjByHandleT( hFocus )

    	if wndFocus and wndFocus:GetClassName() == "EditWnd" and not UI:IsStrEmpty( wndFocus:GetEditText() ) then
    		wndFocus:SetEditText( "" )
    	end

	elseif self.waitMode == self.waitModes.IMPORT_ARC and UI.Login_ArcImportAccountWnd:IsChildOf( self ) then

    	local hFocus = UI:GetKeyboardFocus()
    	local wndFocus = UI:GetUiObjByHandleT( hFocus )

    	if wndFocus and wndFocus:GetClassName() == "EditWnd" and not UI:IsStrEmpty( wndFocus:GetEditText() ) then
    		wndFocus:SetEditText( "" )
    	end

	elseif self.waitMode == self.waitModes.TWO_STEP_AUTHORISATION and UI.Login_TwoStepAuthorisationWnd:IsChildOf( self ) then

    	local hFocus = UI:GetKeyboardFocus()
    	local wndFocus = UI:GetUiObjByHandleT( hFocus )

    	if wndFocus and wndFocus:GetClassName() == "EditWnd" and not UI:IsStrEmpty( wndFocus:GetEditText() ) then
    		wndFocus:SetEditText( "" )
    	end

	end

	return true

end


--
function UI.LoginWnd:UpdateBuildVersion()	

	local verType = cvars.cl_versionType
	local version = string.format( "%s %s", _G.GetAppBuildMark(), verType == "live" and "" or verType )
	self:SetText( version, self.layers.BUILD_VERSION )

end


--
function UI.LoginWnd:F_OnEventComboSelectRecord( hSender, iParam0, iParam1, fParam0, fParam1 )

	if not self:IsOnScreen() then
		return
	end

	if hSender == UI.Login_ServersComboBox:GetUiHandle() then
		self:UpdateConfigAddressFromComboBox()
		self:UpdateServerAddressWnd()
	end

end


--
function UI.LoginWnd:UpdateConfigAddressFromComboBox()

	local selRecordIdx = UI.Login_ServersComboBox:GetSelectedRecord()
	if selRecordIdx == -1 then
		return
	end

	local serverInfo = self.servers[ selRecordIdx ]
	if not serverInfo then
		return
	end

	if serverInfo.name == "server" then
		self:UpdateConfigAddressFromServerAddress()
	else
		cvars.net_masterServerAddress = serverInfo.address or ""
	end

	
end


--
function UI.LoginWnd:UpdateConfigAddressFromServerAddress()

	if self:GetSelectedServerName() ~= "server" then
		return
	end

	local address = UI.Login_ServerNameEditWnd:GetEditText()
	local port = UI.Login_ServerPortEditWnd:GetEditText()

	if not UI:IsStrEmpty( address ) and not UI:IsStrEmpty( port ) then
		address = string.format( "%s:%s", address, port )
	end

	cvars.net_masterServerAddress = address

end


--
function UI.LoginWnd:GetSelectedServerName()

	local selRecordIdx = UI.Login_ServersComboBox:GetSelectedRecord()
	local serverInfo = self.servers[ selRecordIdx ]

	return serverInfo and serverInfo.name or ""

end


--
function UI.LoginWnd:UpdateServerAddressWnd()

	if self:NeedServersComboBox() and self:GetSelectedServerName() == "server" then
		self:AddControl( UI.Login_ServerNameEditWnd, self.layers.MAIN_EFFECT, "server_name" )
		self:AddControl( UI.Login_ServerPortEditWnd, self.layers.MAIN_EFFECT, "server_port" )

		UI.Login_ServerNameEditWnd:UpdateDummyText()
		UI.Login_ServerPortEditWnd:UpdateDummyText()
	else
		self:RemoveControl( UI.Login_ServerNameEditWnd, self.layers.MAIN_EFFECT )
		self:RemoveControl( UI.Login_ServerPortEditWnd, self.layers.MAIN_EFFECT )
		UI.Login_ServerNameEditWnd:SetLayerVisible( false, UI.Login_ServerNameEditWnd.layers.DUMMY_TEXT )
		UI.Login_ServerPortEditWnd:SetLayerVisible( false, UI.Login_ServerPortEditWnd.layers.DUMMY_TEXT )
	end

	self:UpdateFocus()

end


--
function UI.LoginWnd:ValidateConfigAddress()

	if self:NeedServersComboBox() then
		self:UpdateConfigAddressFromComboBox()
		return
	end

	if cvars.net_masterServerAddress == "" then
		cvars.net_masterServerAddress = self.defaultServers[ 1 ].address or ""
	end

end


--
function UI.LoginWnd:CheckShowEula()

	if _G.IsAppDevRun() then
		return
	end

	local profile = _G.GetProfileTable()

	local curVersion = _G.GetAppVersion()
	local prevVersion = profile.eulaAppVersion

	if curVersion == prevVersion then
		return
	end

	if not _G.EULA or type( _G.EULA ) ~= "table" or not next( _G.EULA ) then
		sys.log( "UI.LoginWnd:CheckShowEula()[WARNING]: cannot find \"EULA\" table or the table is empty" )
		return
	end

	self:SetWaitMode( self.waitModes.EULA )
	self:SetEulaIdx( 1, true )

end


--
function UI.LoginWnd:CheckShowNextEula( bNeedAccept )

	if self.waitMode ~= self.waitModes.EULA and self.waitMode ~= self.waitModes.EULA_NOT_NEED_ACCEPT then
		sys.log( "UI.LoginWnd:CheckShowNextEula()[ERROR]: cannot be here" )
		return
	end

	local nextEulaIdx = self.eulaIdx + 1

	if not _G.EULA[ nextEulaIdx ] then

		self:StopWaiting()
		self:HideAgreementWnd()
		self.eulaIdx = -1

	else
		self:SetEulaIdx( nextEulaIdx, bNeedAccept )
	end	
	
end


--
function UI.LoginWnd:SetEulaIdx( eulaIdx, bNeedAccept )

	self.eulaIdx = eulaIdx

	UI.AgreementWnd:SetupForEula( eulaIdx, bNeedAccept )

	if not UI.AgreementWnd:IsOnScreen() then
		UI:PlayGlobalSound( self.sounds.eulaShow )
		UI.AgreementWnd:Show( false )
	end

end


--
function UI.LoginWnd:RequestServerStatus()

	local serverStatusRequestId = -1
	if cvars.net_masterServerStatusUrl ~= "" then
		serverStatusRequestId = _G.MasterServer_RequestServerStatus()
		if serverStatusRequestId == 0 then
			sys.log( "UI.LoginWnd:RequestServerStatus()[ERROR]: fail to request server status" )
			self.serverStatus = -1
		end
	else
		self.serverStatus = nil
	end

	local serverVersionRequestId = -1
	if cvars.net_masterServerVersionUrl ~= "" then
		serverVersionRequestId = _G.MasterServer_RequestServerVersion()
		if serverVersionRequestId == 0 then
			sys.log( "UI.LoginWnd:RequestServerStatus()[ERROR]: fail to request server version" )
			self.serverVersion = "error"
		end
	else
		self.serverVersion = nil
	end

	if serverStatusRequestId == 0 or serverVersionRequestId == 0 then
		self:UpdateWarningText()
		self:UpdateServerStatusText()
		self:UpdateLogInBtn()
	end

	self.serverStatusTimer = ( cvars.net_masterServerStatusUrl ~= "" or cvars.net_masterServerVersionUrl ~= "" ) and self.SERVER_STATUS_REQUEST_TIME or -1

end


--
function UI.LoginWnd:UpdateWarningText()

	local text = ""

	if self.bWaitServers then

		text = UI:GetStringByName( "login_waitingServersList" )
		text = string.format( "%s$effect [effectName hangar_waitText]$", text )

	else

    	local verType = cvars.cl_versionType
    	if verType == "live" or verType == "test" or verType == "pubtest" or verType == "devtest" then

			if self.serverVersion == "error" then
				text = UI:GetStringByName( "login_failRequestServerVersion" )

			elseif not( self.serverVersion == nil or _G.IsCompatibleClientVersion( _G.GetAppVersion(), self.serverVersion ) ) then

				local clientVersionHi, clientVersionLow = _G.MasterServer_ParseVersionStr( _G.GetAppVersion() )
				local serverVersionHi, serverVersionLow = _G.MasterServer_ParseVersionStr( self.serverVersion )

				local bServerVersionIsBetter = UI:IsHiLowGreater( serverVersionHi, serverVersionLow, clientVersionHi, clientVersionLow )

            	local tags =
            	{
            		clientVersion	= _G.GetAppVersion(),
            		serverVersion	= not UI:IsStrEmpty( self.serverVersion ) and self.serverVersion or "unknown",
            	}

        		text = bServerVersionIsBetter and UI:GetStringByName( "login_invalidClientVersion_serverBetter" ) or UI:GetStringByName( "login_invalidClientVersion_clientBetter" )
            	text = string.gsub( text, "%$([%w_]+)%$", tags )

				-- если запущен из под стима и версии не совпадают для verType == "live" or verType == "test" or verType == "pubtest" - вызываем Steam_MarkContentCorrupt и закрываемся по нажатию Ok (#33730)
				if self:IsSteamAccount() and ( verType == "live" or verType == "test" or verType == "pubtest" ) then
					_G.Steam_MarkContentCorrupt()
					local msg = bServerVersionIsBetter and UI:GetStringByName( "msg_error_Steam_Version_serverBetter" ) or UI:GetStringByName( "msg_error_Steam_Version_clientBetter" )
					self.hMsgSteamWrongVersion = UI:MessageBox( UI:GetStringByName( "msgCapt_error" ), msg, UI.MBS_OK )
				end

			elseif self.serverStatus == -1 then
				text = UI:GetStringByName( "login_failRequestServerStatus" )

			elseif not( self.serverStatus == nil or self.serverStatus == _G.MasterServer.ServerStatus.SS_AVAILABLE ) then

        		local statusName = UI:Val2Key( _G.MasterServer.ServerStatus, self.serverStatus )
        		local strStatus = UI:GetStringByName( string.format( "serverStatus_%s", statusName ) )

        		text = UI:GetStringByName( "login_inaccessibleServer" )
        		text = string.format( text, strStatus )

			end

    	end

	end

	self.warningMetaText:SetText( text, true )

end  


--
function UI.LoginWnd:F_OnNewFrame( hSender, dt_sys, dt_game )

	self:UpdateServerStatusTimer( dt_sys )
	self:UpdateCreditsFadeTimer( dt_sys )
	self:UpdateQuestsWaitTimer( dt_sys )
	self:UpdateAdventuresWaitTimer( dt_sys )

	self.warningMetaText:Update( dt_sys )

end


--
function UI.LoginWnd:UpdateServerStatusTimer( dt )

	if self.serverStatusTimer ~= -1 then
		self.serverStatusTimer = self.serverStatusTimer - dt
		if self.serverStatusTimer <= 0 then
			self:RequestServerStatus()
		end
	end

end


--
function UI.LoginWnd:UpdateCreditsFadeTimer( dt )

	if self.creditsFadeTimer ~= -1 then

		self.creditsFadeTimer = self.creditsFadeTimer - dt
		if self.creditsFadeTimer <= 0 then

			self.creditsFadeTimer = -1
			self:DoShowCredits()

		end

	end

end


--
function UI.LoginWnd:UpdateQuestsWaitTimer( dt )

	if self.questsWaitTimer ~= -1 then

		self.questsWaitTimer = self.questsWaitTimer - dt
		if self.questsWaitTimer <= 0 then

			self.questsRequestId = 0
			self.questsWaitTimer = -1

			self:CheckLoadDataComplete()

		end

	end

end


--
function UI.LoginWnd:UpdateAdventuresWaitTimer( dt )

	if self.adventuresWaitTimer ~= -1 then

		self.adventuresWaitTimer = self.adventuresWaitTimer - dt
		if self.adventuresWaitTimer <= 0 then

			self.adventuresRequestId = 0
			self.adventuresWaitTimer = -1

			self:CheckLoadDataComplete()

		end

	end

end


--
function UI.LoginWnd:HideNewsWnd()

	self:RemoveChild( UI.NewsWnd )

end


--
function UI.LoginWnd:ShowNewsWnd()

	self:AddChild( UI.NewsWnd )

end


--
function UI.LoginWnd:RequestNews()

	self.news = {}

	if cvars.net_masterServerNewsFeedUrl == "" then
		return
	end

	if _G.MasterServer_RequestNewsFeed() == 0 then
		sys.log( "UI.LoginWnd:RequestNews()[ERROR]: fail to request news" )
	end

end

  
--
function UI.LoginWnd:RequestServersList()

	if cvars.net_masterServerAddressesUrl == "" then
		self.bWaitServers = false
		self.servers = self.defaultServers
		return
	end

	self.bWaitServers = true

	if _G.MasterServer_RequestServerAddresess() == 0 then

		sys.log( "UI.LoginWnd:RequestServersList()[WARNING]: fail to request servers list" )

		self.bWaitServers = false
		self.servers = self.defaultServers

		self:UpdateServersComboBox()
		self:UpdateWarningText()
		self:UpdateLogInBtn()

	end

end


--
function UI.LoginWnd:F_DrawLayer( x0, y0, width, height, clipX0, clipY0, clipWidth, clipHeight, layerIdx )

	if layerIdx == self.layers.WARNING then
		self.warningMetaText:Draw( clipX0, clipY0, clipWidth, clipHeight )
	end

end


--
function UI.LoginWnd:UpdateFocus()

	if self.waitMode == self.waitModes.NONE then

		if UI.Login_ServerNameEditWnd:IsChildOf( self ) and UI:IsStrEmpty( UI.Login_ServerNameEditWnd:GetEditText() ) then
			self:SetDefaultActivatableChild( UI.Login_ServerNameEditWnd:GetName() )
		elseif UI.Login_ServerPortEditWnd:IsChildOf( self ) and UI:IsStrEmpty( UI.Login_ServerPortEditWnd:GetEditText() ) then
			self:SetDefaultActivatableChild( UI.Login_ServerPortEditWnd:GetName() )
    	elseif UI:IsStrEmpty( UI.Login_AccountEditWnd:GetEditText() ) then
    		self:SetDefaultActivatableChild( UI.Login_AccountEditWnd:GetName() )
    	else
    		self:SetDefaultActivatableChild( UI.Login_PasswordEditWnd:GetName() )
    	end


	elseif self.waitMode == self.waitModes.IMPORT_STEAM and UI.Login_SteamImportAccountWnd:IsChildOf( self ) then

		self:SetDefaultActivatableChild( UI.Login_SteamImportAccountWnd:GetName() )

    	if UI:IsStrEmpty( UI.Login_SteamImportAccount_AccountEditWnd:GetEditText() ) then
    		UI.Login_SteamImportAccountWnd:SetDefaultActivatableChild( UI.Login_SteamImportAccount_AccountEditWnd:GetName() )
    	else
    		UI.Login_SteamImportAccountWnd:SetDefaultActivatableChild( UI.Login_SteamImportAccount_PasswordEditWnd:GetName() )
    	end


	elseif self.waitMode == self.waitModes.IMPORT_ARC and UI.Login_ArcImportAccountWnd:IsChildOf( self ) then

		self:SetDefaultActivatableChild( UI.Login_ArcImportAccountWnd:GetName() )

    	if UI:IsStrEmpty( UI.Login_ArcImportAccount_AccountEditWnd:GetEditText() ) then
    		UI.Login_ArcImportAccountWnd:SetDefaultActivatableChild( UI.Login_ArcImportAccount_AccountEditWnd:GetName() )
    	else
    		UI.Login_ArcImportAccountWnd:SetDefaultActivatableChild( UI.Login_ArcImportAccount_PasswordEditWnd:GetName() )
    	end


	elseif self.waitMode == self.waitModes.TWO_STEP_AUTHORISATION and UI.Login_TwoStepAuthorisationWnd:IsChildOf( self ) then

		self:SetDefaultActivatableChild( UI.Login_TwoStepAuthorisationWnd:GetName() )
    	UI.Login_TwoStepAuthorisationWnd:SetDefaultActivatableChild( UI.Login_TwoStepAuthorisation_KeyEditWnd:GetName() )

	else
		self:SetDefaultActivatableChild( "" )
	end

	UI:ValidateKeyboardFocus()

end


--
function UI.LoginWnd:ResetFocus()

	self:SetDefaultActivatableChild( "" )
	UI:ValidateKeyboardFocus()

end


--
function UI.LoginWnd:UpdateAuthorizationControls()

	self:ResetAuthorizationControls()

	if self:IsSteamAccount() then
		self:ShowSteamAuthorizationControls()
		self:UpdateLogInBtn()

	elseif self:IsArcAccount() then
		self:ShowArcAuthorizationControls()
		self:UpdateLogInBtn()

	else
		self:ShowCommonAuthorizationControls()
		self:RestoreSavedAuthorizationData()
		self:UpdateLogInBtn()
	end

end    


--
function UI.LoginWnd:ResetAuthorizationControls()

	self:ResetSteamAuthorizationControls()
	self:ResetArcAuthorizationControls()
	self:ResetCommonAuthorizationControls()

end


--
function UI.LoginWnd:ResetSteamAuthorizationControls()

	self:RemoveControl( UI.Login_SteamImportAccountWnd, self.layers.MAIN_EFFECT )
	self:RemoveControl( UI.Login_SteamLogInBtn, self.layers.MAIN_EFFECT )

	self:SetLayerVisible( false, self.layers.STEAM_LOGIN_TIP )

	UI.Login_SteamImportAccountWnd:Reset()

end


--
function UI.LoginWnd:ResetArcAuthorizationControls()

	self:RemoveControl( UI.Login_ArcImportAccountWnd, self.layers.MAIN_EFFECT )
	self:RemoveControl( UI.Login_ArcLogInBtn, self.layers.MAIN_EFFECT )

	self:SetLayerVisible( false, self.layers.ARC_LOGIN_TIP )

	UI.Login_ArcImportAccountWnd:Reset()

end


--
function UI.LoginWnd:ShowSteamAuthorizationControls()

	self:AddControl( UI.Login_SteamLogInBtn, self.layers.MAIN_EFFECT, self.effectInfo.main.steamLogInBtnLocator )
	self:SetLayerVisible( true, self.layers.STEAM_LOGIN_TIP )

end


--
function UI.LoginWnd:ShowArcAuthorizationControls()

	self:AddControl( UI.Login_ArcLogInBtn, self.layers.MAIN_EFFECT, self.effectInfo.main.arcLogInBtnLocator )
	self:SetLayerVisible( true, self.layers.ARC_LOGIN_TIP )

end


--
function UI.LoginWnd:ResetArcAuthorizationControls()

	self:RemoveControl( UI.Login_ArcImportAccountWnd, self.layers.MAIN_EFFECT )
	self:RemoveControl( UI.Login_ArcLogInBtn, self.layers.MAIN_EFFECT )

	self:SetLayerVisible( false, self.layers.ARC_LOGIN_TIP )

	UI.Login_ArcImportAccountWnd:Reset()

end


--
function UI.LoginWnd:ShowArcAuthorizationControls()

	self:AddControl( UI.Login_ArcLogInBtn, self.layers.MAIN_EFFECT, self.effectInfo.main.arcLogInBtnLocator )
	self:SetLayerVisible( true, self.layers.ARC_LOGIN_TIP )

end


--
function UI.LoginWnd:ResetCommonAuthorizationControls()

	self:RemoveControl( UI.Login_AccountEditWnd, self.layers.ACCOUNT_EFFECT )
	self:RemoveControl( UI.Login_PasswordEditWnd, self.layers.PASSWORD_EFFECT )
	self:RemoveControl( UI.Login_ForgetBtn, self.layers.MAIN_EFFECT )
	self:RemoveControl( UI.Login_RegisterBtn, self.layers.MAIN_EFFECT )
	self:RemoveControl( UI.Login_RememberCheckBox, self.layers.MAIN_EFFECT )
	self:RemoveControl( UI.Login_LogInBtn, self.layers.MAIN_EFFECT )

	self:SetLayerVisible( false, self.layers.ACCOUNT_LABEL )
	self:SetLayerVisible( false, self.layers.PASSWORD_LABEL )

	UI.Login_AccountEditWnd:SetEditText( "" )
	UI.Login_PasswordEditWnd:SetEditText( "" )
	UI.Login_RememberCheckBox:Check( false )

end


--
function UI.LoginWnd:ShowCommonAuthorizationControls()

	self:AddControl( UI.Login_AccountEditWnd, self.layers.ACCOUNT_EFFECT, self.effectInfo.account.editWndLocator )
	self:AddControl( UI.Login_PasswordEditWnd, self.layers.PASSWORD_EFFECT, self.effectInfo.password.editWndLocator )
	--self:AddControl( UI.Login_ForgetBtn, self.layers.MAIN_EFFECT, self.effectInfo.main.forgetBtnLocator )
	--self:AddControl( UI.Login_RegisterBtn, self.layers.MAIN_EFFECT, self.effectInfo.main.registerBtnLocator )
	self:AddControl( UI.Login_RememberCheckBox, self.layers.MAIN_EFFECT, self.effectInfo.main.rememberCheckBoxLocator )
	self:AddControl( UI.Login_LogInBtn, self.layers.MAIN_EFFECT, self.effectInfo.main.logInBtnLocator )

	self:SetLayerVisible( true, self.layers.ACCOUNT_LABEL )
	self:SetLayerVisible( true, self.layers.PASSWORD_LABEL )

end


-- игра запущена из-под стима?
function UI.LoginWnd:IsSteamAccount()

	return _G.Steam_GetLocalSteamID() ~= UI.INVALID_U64_ID

end


-- аналог IsSteamAccount() для Arc
function UI.LoginWnd:IsArcAccount()

	return _G.Arc_IsInitialized()

end


-- используются правила логина для стима?
function UI.LoginWnd:IsUsingSteamAccount()

	return self:IsSteamAccount()

end


-- аналог IsUsingSteamAccount() для Arc
function UI.LoginWnd:IsUsingArcAccount()

	return self:IsArcAccount()

end


--
function UI.LoginWnd:F_OnAfterAddChild( child )

	self:OnAfterAddChild( child )

	self:UpdateZOrder()

end


--
function UI.LoginWnd:UpdateZOrder()

	if UI.Login_SteamImportAccountBox and UI.Login_SteamImportAccountBox.w and UI.Login_SteamImportAccountBox:IsChildOf( self ) then
		self:MoveChildToLastPosition( UI.Login_SteamImportAccountBox )
	end

	if UI.Login_ArcImportAccountBox and UI.Login_ArcImportAccountBox.w and UI.Login_ArcImportAccountBox:IsChildOf( self ) then
		self:MoveChildToLastPosition( UI.Login_ArcImportAccountBox )
	end

	if UI.Login_SteamImportAccountWnd and UI.Login_SteamImportAccountWnd.w and UI.Login_SteamImportAccountWnd:IsChildOf( self ) then
		self:MoveChildToLastPosition( UI.Login_SteamImportAccountWnd )
	end

	if UI.Login_ArcImportAccountWnd and UI.Login_ArcImportAccountWnd.w and UI.Login_ArcImportAccountWnd:IsChildOf( self ) then
		self:MoveChildToLastPosition( UI.Login_ArcImportAccountWnd )
	end

	if UI.Login_WaitingWnd and UI.Login_WaitingWnd.w and UI.Login_WaitingWnd:IsChildOf( self ) then
		self:MoveChildToLastPosition( UI.Login_WaitingWnd )
	end

	if UI.Login_ConnectingWnd and UI.Login_ConnectingWnd.w and UI.Login_ConnectingWnd:IsChildOf( self ) then
		self:MoveChildToLastPosition( UI.Login_ConnectingWnd )
	end

end


--
function UI.LoginWnd:F_OnEventWndHided( hSender, hWnd )

	if not self:IsOnScreen() then
		return
	end

	if UI.CreditsWnd and UI.CreditsWnd:GetUiHandle() == hSender and self.waitMode == self.waitModes.CREDITS then
		self:StopWaiting()
	end

end


--
function UI.LoginWnd:ResetCancelConnectingMsg()

	if self.hMsgCancelConnecting ~= UI.INVALID_UI_HANDLE then

		UI:RemoveUiObj( self.hMsgCancelConnecting )
		self.hMsgCancelConnecting = UI.INVALID_UI_HANDLE
	end

end


--
function UI.LoginWnd:UpdateServerStatusText()

	local str = ""

	if self.serverStatus ~= nil and self.serverStatus ~= -1 then

		local statusStrId = ( _G.MasterServer.ServerStatus.SS_AVAILABLE == self.serverStatus ) and "login_serverStatusVal_online" or "login_serverStatusVal_offline"
		local strStatus = UI:GetStringByName( statusStrId )		

		local strLabel = UI:GetStringByName( "login_serverStatusLabel" )

		str = string.format( "%s: %s", strLabel, strStatus )

	end

	self:SetText( str, self.layers.SERVER_STATUS )

end


--
function UI.LoginWnd:AddControl( wnd, effectLayer, locatorName )

	if not wnd then
		return
	end

    local effect = UI:GetEffectFromLayer( self, effectLayer )

	if wnd:IsChildOf( self ) and effect then
    	effect:UnlinkWnd( wnd:GetUiHandle(), "" )
	end

	UI:AddChildAndLink( self, wnd, effect, locatorName, UI.EffectAnimParams.POS )

end


--
function UI.LoginWnd:RemoveControl( wnd, effectLayer )

	if not wnd or not wnd:IsChildOf( self ) then
		return
	end

	wnd:UnlinkFromParent()

	local effect = UI:GetEffectFromLayer( self, effectLayer )
	if effect then
		effect:UnlinkWnd( wnd:GetUiHandle(), "" )
	end

end


--
function UI.LoginWnd:ShowSteamImportRequestBox()	

	self:AddChild( UI.Login_SteamImportAccountBox )	
	self:UpdateFocus()

end


--
function UI.LoginWnd:ShowArcImportRequestBox()	

	self:AddChild( UI.Login_ArcImportAccountBox )	
	self:UpdateFocus()

end


--
function UI.LoginWnd:HideSteamImportRequestBox()	

	UI.Login_SteamImportAccountBox:UnlinkFromParent()	
	self:UpdateFocus()

end


--
function UI.LoginWnd:HideArcImportRequestBox()	

	UI.Login_ArcImportAccountBox:UnlinkFromParent()	
	self:UpdateFocus()

end


--
function UI.LoginWnd:ShowSteamImportRequestWnd()	

	self:AddChild( UI.Login_SteamImportAccountWnd )
	self:UpdateFocus()

end


--
function UI.LoginWnd:ShowArcImportRequestWnd()	

	self:AddChild( UI.Login_ArcImportAccountWnd )
	self:UpdateFocus()

end


--
function UI.LoginWnd:HideSteamImportRequestWnd()	

	UI.Login_SteamImportAccountWnd:UnlinkFromParent()
	self:UpdateFocus()

end


--
function UI.LoginWnd:HideArcImportRequestWnd()	

	UI.Login_ArcImportAccountWnd:UnlinkFromParent()
	self:UpdateFocus()

end


--
function UI.LoginWnd:ResetSteamImportAccountControls()

	self:HideSteamImportRequestBox()	
	self:HideSteamImportRequestWnd()

end


--
function UI.LoginWnd:ResetArcImportAccountControls()

	self:HideArcImportRequestBox()	
	self:HideArcImportRequestWnd()

end


--
function UI.LoginWnd:CreateSteamUnattachedAccount()

	if self.waitMode ~= self.waitModes.IMPORT_STEAM then
		sys.log( "UI.LoginWnd:CreateSteamUnattachedAccount()[ERROR]: invalid mode: %s", tostring( self.waitMode ) )
		return
	end

	if _G.MasterServer_ChooseSteamAttachmentLoginPassword( "", "" ) then
		self:SetWaitMode( self.waitModes.IMPORT_STEAM_CONNECTING )	
	else
		self:StopWaiting()
		self:ShowMsgOnSteamImportAccountError()
	end

	self:ResetSteamImportAccountControls()

end


--
function UI.LoginWnd:ImportSteamAccount()

	if self.waitMode ~= self.waitModes.IMPORT_STEAM then
		sys.log( "UI.LoginWnd:ImportSteamAccount()[ERROR]: invalid mode: %s", tostring( self.waitMode ) )
		return
	end

	if not UI.Login_SteamImportAccount_AccountEditWnd:IsOnScreen() then
		sys.log( "UI.LoginWnd:ImportSteamAccount()[ERROR]: Login_SteamImportAccount_AccountEditWnd is not on sreen" )
		return
	end

	if _G.MasterServer_ChooseSteamAttachmentLoginPassword( UI.Login_SteamImportAccount_AccountEditWnd:GetEditText(), UI.Login_SteamImportAccount_PasswordEditWnd:GetEditText() ) then
		self:SetWaitMode( self.waitModes.IMPORT_STEAM_CONNECTING )	
	else
		self:StopWaiting()
		self:ShowMsgOnSteamImportAccountError()
	end

	self:ResetSteamImportAccountControls()

end


--
function UI.LoginWnd:ImportArcAccount()

	if self.waitMode ~= self.waitModes.IMPORT_ARC then
		sys.log( "UI.LoginWnd:ImportArcAccount()[ERROR]: invalid mode: %s", tostring( self.waitMode ) )
		return
	end

	if not UI.Login_ArcImportAccount_AccountEditWnd:IsOnScreen() then
		sys.log( "UI.LoginWnd:ImportArcAccount()[ERROR]: Login_ArcImportAccount_AccountEditWnd is not on sreen" )
		return
	end

	if _G.MasterServer_ChooseArcAttachmentLoginPassword( UI.Login_ArcImportAccount_AccountEditWnd:GetEditText(), UI.Login_ArcImportAccount_PasswordEditWnd:GetEditText() ) then
		self:SetWaitMode( self.waitModes.IMPORT_ARC_CONNECTING )	
	else
		self:StopWaiting()
		self:ShowMsgOnArcImportAccountError()
	end

	self:ResetArcImportAccountControls()

end


--
function UI.LoginWnd:CancelSteamImport()

	if self.waitMode ~= self.waitModes.IMPORT_STEAM then
		sys.log( "UI.LoginWnd:CancelSteamImport()[ERROR]: invalid mode: %s", tostring( self.waitMode ) )
		return
	end

	self:LogOut()

end


--
function UI.LoginWnd:CancelArcImport()

	if self.waitMode ~= self.waitModes.IMPORT_ARC then
		sys.log( "UI.LoginWnd:CancelArcImport()[ERROR]: invalid mode: %s", tostring( self.waitMode ) )
		return
	end

	self:LogOut()

end


--
function UI.LoginWnd:ShowMsgOnSteamImportAccountError()

	UI:ShowErrorMsg( "login_msg_importError" )

end


--
function UI.LoginWnd:ShowMsgOnArcImportAccountError()

	UI:ShowErrorMsg( "login_msg_importError" )

end


--
function UI.LoginWnd:ShowTwoStepAuthorisationWnd()

	if UI.Login_TwoStepAuthorisationWnd:IsChildOf( self ) then
		return
	end

	UI.Login_TwoStepAuthorisationWnd:Reset()
	self:AddChild( UI.Login_TwoStepAuthorisationWnd )

	self:UpdateFocus()

end


--
function UI.LoginWnd:HideTwoStepAuthorisationWnd()

	if not UI.Login_TwoStepAuthorisationWnd:IsChildOf( self ) then
		return
	end

	UI.Login_TwoStepAuthorisationWnd:UnlinkFromParent()

	self:UpdateFocus()

end


-- ------------------------------------------------------------------------
-- UI.Login_EditWnd
-- ------------------------------------------------------------------------

UI.Login_EditWnd =
{
    def =
    {   	
     	className	= "EditWnd",
    	prototype	= "EffectEditWnd",

     	props =
     	{
     		name			= "Login_EditWnd",
     		activationOrder	= -1,
    		isPrototype		= true,
     	},

     	layers =
     	{
    		-- MAIN_EFFECT
    		{
    			layerType	= UI.LAYER_EFFECT,
    			layerStyle	= UI.WLS_RESIZABLE,

    			effects =
    			{{
    			  	defName				= "login_edit",
    				defaultAnimation    = "deselect",

    				links =
    				{
    					{
    						objName		= "self",
    						animParams	= UI.EffectAnimParams.SIZE,
    					},
    				}
    			}}			
    		},
     	}
    },

    effectInfo =
    {
    	main =
    	{
    		textObjName				= "login",
    		selectionColorObjName	= "select_color",
    		cursorColorObjName		= "cursor",
    		animActive				= "select",
    		animInactive			= "deselect",
    	}
    }
}

-- ------------------------------------------------------------------------
-- UI.Login_AccountEditWnd, UI.Login_PasswordEditWnd
-- ------------------------------------------------------------------------

--
UI.Login_AccountEditWnd =
{
    def =
    {   	
     	className	= "EditWnd",
    	prototype	= "Login_EditWnd",

     	props =
     	{
     		name		= "Login_AccountEditWnd",
    		symbolsLimit= 123,
    	}
    }
}


--
UI.Login_PasswordEditWnd =
{
    def =
    {   	
     	className	= "EditWnd",
    	prototype	= "Login_EditWnd",

     	props =
     	{
     		name			= "Login_PasswordEditWnd",
			editStyle		= UI.ES_SELECT_ON_FOCUS + UI.ES_AUTOSCROLL + UI.ES_PASS,
    		symbolsLimit	= 127,
    	}
    }
}

UI.Login_ServerNameEditWnd = {}

UI.Login_ServerNameEditWnd.layers =
{
    MAIN_EFFECT	= 0,
    SELECTION	= 1,
    TEXT		= 2,
    CURSOR		= 3,
	DUMMY_TEXT	= 4,
}

UI.Login_ServerNameEditWnd.def =
{
	className	= "EditWnd",
	prototype	= "EffectEditWnd",

	props =
	{
		name			= "Login_ServerNameEditWnd",
		symbolsLimit	= 255,
		editStyle		= UI.ES_SELECT_ON_FOCUS + UI.ES_AUTOSCROLL,
		activationOrder	= -1,
	},

	layers =
	{
		numLayers = UI:GetTableLength( UI.Login_ServerNameEditWnd.layers ),

		-- MAIN_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "comboBox1_edit",
				defaultAnimation    = "deselect",

				links =
				{
					{
						objName		= "self",
						animParams	= UI.EffectAnimParams.SIZE,
					},

					{
						objName		= "simple_color",
						layer		= "UI.Login_ServerNameEditWnd.layers.DUMMY_TEXT",
						animParams	= UI.EffectAnimParams.COLOR,
					},
				}
			}}
		},

		-- DUMMY_TEXT
		{
			id				= UI.Login_ServerNameEditWnd.layers.DUMMY_TEXT,
			layerType		= UI.LAYER_TEXT,
			formatFlags		= FONT.TF_LEFT + FONT.TF_VCENTER + FONT.TF_SINGLELINE,
			formatInfoSz	= { 1, 1 },
			font			= { fontName = "Small" },
			text			= UI:GetStringByName( "login_serverName" ),
		},
	}
}

UI.Login_ServerNameEditWnd.effectInfo =
{
	main =
	{
		textObjName				= "login",
		selectionColorObjName	= "select_color",
		cursorColorObjName		= "cursor",
		animActive				= "select",
		animInactive			= "deselect",
		animDisabled			= "disable",
	}
}


--
function UI.Login_ServerNameEditWnd:F_PostLoad()

	UI.EffectEditWnd.F_PostLoad( self )

	local textRect = self:GetLayerRect( self.layers.TEXT )
	self:SetLayerRect( textRect, self.layers.DUMMY_TEXT )

	local handle = self:GetUiHandle()
	UI:SubscribeUiObjOnEvent( handle, UI.EV_EDIT_CHANGE )

end


--
function UI.Login_ServerNameEditWnd:F_OnEventEditChange( hSender, eventSrc )

	if hSender ~= self:GetUiHandle() then
		return
	end

	self:UpdateDummyText()

end


--
function UI.Login_ServerNameEditWnd:UpdateDummyText()

	local bVisible = self:IsOnScreen() and self:GetEditText() == "" and UI:GetKeyboardFocus() ~= self:GetUiHandle()
	self:SetLayerVisible( bVisible, self.layers.DUMMY_TEXT )

end


--
function UI.Login_ServerNameEditWnd:F_OnObtainKeyboardFocus()

	UI.EffectEditWnd.F_OnObtainKeyboardFocus( self )
	self:UpdateDummyText()

end


--
function UI.Login_ServerNameEditWnd:F_OnLostKeyboardFocus()

	UI.EffectEditWnd.F_OnLostKeyboardFocus( self )
	self:UpdateDummyText()

end


UI.Login_ServerPortEditWnd = {}

UI.Login_ServerPortEditWnd.layers =
{
    MAIN_EFFECT	= 0,
    SELECTION	= 1,
    TEXT		= 2,
    CURSOR		= 3,
	DUMMY_TEXT	= 4,
}

UI.Login_ServerPortEditWnd.def =
{
	className	= "EditWnd",
	prototype	= "EffectEditWnd",

	props =
	{
		name			= "Login_ServerPortEditWnd",
		symbolsLimit	= 5,
		editStyle		= UI.ES_SELECT_ON_FOCUS + UI.ES_AUTOSCROLL,
		activationOrder	= -1,
	},

	layers =
	{
		numLayers = UI:GetTableLength( UI.Login_ServerPortEditWnd.layers ),

		-- MAIN_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "trading_createAdvert_priceEdit",
				defaultAnimation    = "deselect",

				links =
				{
					{
						objName		= "self",
						animParams	= UI.EffectAnimParams.SIZE,
					},

					{
						objName		= "simple_color",
						layer		= "UI.Login_ServerPortEditWnd.layers.DUMMY_TEXT",
						animParams	= UI.EffectAnimParams.COLOR,
					},
				}
			}}
		},

		-- DUMMY_TEXT
		{
			id				= UI.Login_ServerPortEditWnd.layers.DUMMY_TEXT,
			layerType		= UI.LAYER_TEXT,
			formatFlags		= FONT.TF_LEFT + FONT.TF_VCENTER + FONT.TF_SINGLELINE,
			formatInfoSz	= { 1, 1 },
			font			= { fontName = "Small" },
			text			= UI:GetStringByName( "login_serverPort" ),
		},
	}
}

UI.Login_ServerPortEditWnd.effectInfo =
{
	main =
	{
		textObjName				= "login",
		selectionColorObjName	= "select_color",
		cursorColorObjName		= "cursor",
		animActive				= "select",
		animInactive			= "deselect",
		animDisabled			= "disable",
	}
}


--
function UI.Login_ServerPortEditWnd:F_PostLoad()

	UI.EffectEditWnd.F_PostLoad( self )

	local textRect = self:GetLayerRect( self.layers.TEXT )
	self:SetLayerRect( textRect, self.layers.DUMMY_TEXT )

	local handle = self:GetUiHandle()
	UI:SubscribeUiObjOnEvent( handle, UI.EV_EDIT_CHANGE )

end


--
function UI.Login_ServerPortEditWnd:F_OnEventEditChange( hSender, eventSrc )

	if hSender ~= self:GetUiHandle() then
		return
	end

	self:UpdateDummyText()

end


--
function UI.Login_ServerPortEditWnd:UpdateDummyText()

	local bVisible = self:IsOnScreen() and self:GetEditText() == "" and UI:GetKeyboardFocus() ~= self:GetUiHandle()
	self:SetLayerVisible( bVisible, self.layers.DUMMY_TEXT )

end


--
function UI.Login_ServerPortEditWnd:F_OnObtainKeyboardFocus()

	UI.EffectEditWnd.F_OnObtainKeyboardFocus( self )
	self:UpdateDummyText()

end


--
function UI.Login_ServerPortEditWnd:F_OnLostKeyboardFocus()

	UI.EffectEditWnd.F_OnLostKeyboardFocus( self )
	self:UpdateDummyText()

end


-- ------------------------------------------------------------------------
-- UI.Login_LogInBtn
-- ------------------------------------------------------------------------

local l_effectBtnNumLayers = UI:GetTableLength( UI.EffectButtonWnd.layers )

UI.Login_LogInBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "EffectButtonWnd",

    	props =
    	{
    		name			= "Login_LogInBtn",
			selectSound		= lw.sounds.btnMouseOver,
			clickSound		= lw.sounds.btnClick,
    	},

        layers =
        {
    		numLayers = l_effectBtnNumLayers + 1,

        	-- MAIN_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,
    			main		= true,

    			effects =
    			{{
    				defName				= "login_logInBtn",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "self",
    						animParams	= UI.EffectAnimParams.SIZE,
    					},

    					{
    						objName		= "value",
    						layer		= "UI.Login_LogInBtn.layers.TEXT",
    						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},
    				}
    			}}
        	},

        	-- TEXT
        	{
				id = l_effectBtnNumLayers,

       			layerType	= UI.LAYER_TEXT,

       			formatInfoSz= { 1, 1 },
       			formatFlags	= FONT.TF_NOCLIP + FONT.TF_SINGLELINE,
       			font =
        		{
    				fontName = "Small", 
       			},
				text = "^login_btnLogin",
        	}, 
        }
    },

    layers =
    {
        MAIN_EFFECT		= 0,
        DEBUG			= 1,
        TEXT			= 2,
    },

    effectInfo =
    {
    	main =
    	{
    		animationIdle 		= "idle",
    		animationSelect		= "over",
    		animationPressed	= "press",
    		animationDisabled	= "disable",
    	},
    }
}


-- ------------------------------------------------------------------------
-- UI.Login_Btn
-- ------------------------------------------------------------------------

UI.Login_Btn = {}

-- -----------------------------------
-- window definition
-- -----------------------------------

UI.Login_Btn.def =
{
	className 	= "ButtonWnd",
	prototype	= "EffectButtonWnd",

	props =
	{
		name			= "Login_Btn",
		selectSound		= lw.sounds.btnMouseOver,
		clickSound		= lw.sounds.btnClick,
		isPrototype		= true,
	},

    layers =
    {
		numLayers = l_effectBtnNumLayers + 1,

    	-- MAIN_EFFECT
    	{
    		layerType	= UI.LAYER_EFFECT,
    		layerStyle	= UI.WLS_RESIZABLE,
			main		= true,

			effects =
			{{
				defName				= "login_simpleBtn",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "self",
						animParams	= UI.EffectAnimParams.SIZE,
					},

					{
						objName		= "value",
						layer		= "UI.Login_Btn.layers.TEXT",
						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},
				}
			}}
    	},

    	-- TEXT
    	{
			id = l_effectBtnNumLayers,

   			layerType	= UI.LAYER_TEXT,

   			formatInfoSz= { 1, 1 },
   			formatFlags	= FONT.TF_NOCLIP + FONT.TF_SINGLELINE,
   			font =
    		{
				fontName = "Small", 
   			},
    	}, 
    }
}

-- -----------------------------------
-- const
-- -----------------------------------

UI.Login_Btn.layers =
{
    MAIN_EFFECT		= 0,
    DEBUG			= 1,
    TEXT			= 2,
}

UI.Login_Btn.effectInfo =
{
	main =
	{
		animationIdle 		= "idle",
		animationSelect		= "over",
		animationPressed	= "press",
		animationDisabled	= "disable",
	},
}

UI.Login_Btn.textId = ""
UI.Login_Btn.customText = ""

-- -----------------------------------
-- work functions
-- -----------------------------------

--
function UI.Login_Btn:F_PostLoad()

	UI.EffectButtonWnd.F_PostLoad( self )

	if self.customText ~= "" then
		self:SetText( self.customText, self.layers.TEXT )
	elseif self.textId ~= "" then
		self:SetText( UI:GetStringByName( self.textId ), self.layers.TEXT )
	end

end


-- ------------------------------------------------------------------------
-- UI.Login_Btn
-- ------------------------------------------------------------------------

UI.Login_BigBtn = {}

-- -----------------------------------
-- window definition
-- -----------------------------------

UI.Login_BigBtn.def =
{
	className 	= "ButtonWnd",
	prototype	= "Login_Btn",

	props =
	{
		name			= "Login_BigBtn",
		isPrototype		= true,
	},

	layers =
	{
		-- MAIN_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,
			main		= true,
	
			effects =
			{{
				defName				= "login_simpleBigBtn",
				defaultAnimation    = "idle",
	
				links =
				{
					{
						objName		= "self",
						animParams	= UI.EffectAnimParams.SIZE,
					},
	
					{
						objName		= "value",
						layer		= "UI.Login_Btn.layers.TEXT",
						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},
				}
			}}
		},
	}
}


-- ------------------------------------------------------------------------
-- UI.Login_RegisterBtn
-- ------------------------------------------------------------------------

UI.Login_RegisterBtn = {}

-- -------------------------
-- window definition
-- -------------------------

UI.Login_RegisterBtn.def =
{
	className 	= "ButtonWnd",
	prototype	= "Login_Btn",

	props =
	{
		name			= "Login_RegisterBtn",
	},
}

-- -------------------------
-- interface functions
-- -------------------------

--
function UI.Login_RegisterBtn:SetTextColorRegular()

	local mainEffect = UI:GetEffectFromLayer( self, self.layers.MAIN_EFFECT )	
	if not mainEffect then
		return
	end

	local handle = self:GetUiHandle()
	
	mainEffect:UnlinkLayer( handle, self.layers.TEXT, self.effectInfo.main.specColorLocator )
	mainEffect:LinkLayer( handle, self.layers.TEXT, self.effectInfo.main.textLocator, UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND )

end


--
function UI.Login_RegisterBtn:SetTextColorSpecial()

	local mainEffect = UI:GetEffectFromLayer( self, self.layers.MAIN_EFFECT )	
	if not mainEffect then
		return
	end

	local handle = self:GetUiHandle()

	mainEffect:LinkLayer( handle, self.layers.TEXT, self.effectInfo.main.specColorLocator, UI.EffectAnimParams.COLOR )
	mainEffect:LinkLayer( handle, self.layers.TEXT, self.effectInfo.main.textLocator, UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND )

end


-- -------------------------
-- const
-- -------------------------

UI.Login_RegisterBtn.textId = "login_btnRegister"

UI.Login_RegisterBtn.effectInfo =
{
	main =
	{
		animationIdle 		= "idle",
		animationSelect		= "over",
		animationPressed	= "press",
		animationDisabled	= "disable",

		specColorLocator	= "color_1",
		textLocator			= "value",
	}
}

-- ------------------------------------------------------------------------
-- UI.Login_ForgetBtn
-- ------------------------------------------------------------------------

UI.Login_ForgetBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_ForgetBtn",
    	},
	},

	textId = "login_btnForget",
}


-- ------------------------------------------------------------------------
-- UI.Login_OptionsBtn
-- ------------------------------------------------------------------------

UI.Login_OptionsBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_OptionsBtn",
			clickSound		= "",
    	},
	},

	textId = "login_btnOptions",
}

-- ------------------------------------------------------------------------
-- UI.Login_LicenseBtn
-- ------------------------------------------------------------------------

UI.Login_LicenseBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_BigBtn",

    	props =
    	{
    		name			= "Login_LicenseBtn",
			clickSound		= "",
    	},
	},

	textId = "login_btnLicense",
}

-- ------------------------------------------------------------------------
-- UI.Login_CreditsBtn
-- ------------------------------------------------------------------------

UI.Login_CreditsBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_CreditsBtn",
    	},
	},

	textId = "login_btnCredits",
}

-- ------------------------------------------------------------------------
-- UI.Login_SiteBtn
-- ------------------------------------------------------------------------

UI.Login_SiteBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_SiteBtn",
    	},
	},

	textId = "login_btnSite",
}


-- ------------------------------------------------------------------------
-- UI.Login_SupportBtn
-- ------------------------------------------------------------------------

UI.Login_SupportBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_SupportBtn",
    	},
	},

	textId = "menu_Support",
}

-- ------------------------------------------------------------------------
-- UI.Login_StartServerBtn
-- ------------------------------------------------------------------------

UI.Login_StartServerBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_StartServerBtn",
    	},
	},

	customText = "DISCORD",
}

-- ------------------------------------------------------------------------
-- UI.Login_QuitBtn
-- ------------------------------------------------------------------------

UI.Login_QuitBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "EffectButtonWnd",

    	props =
    	{
    		name			= "Login_QuitBtn",
			selectSound		= lw.sounds.btnMouseOver,
			clickSound		= lw.sounds.btnClick,
    	},

        layers =
        {
    		numLayers = l_effectBtnNumLayers + 1,

        	-- MAIN_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,
    			main		= true,

    			effects =
    			{{
    				defName				= "login_quitBtn",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "self",
    						animParams	= UI.EffectAnimParams.SIZE,
    					},

    					{
    						objName		= "value",
    						layer		= "UI.Login_QuitBtn.layers.TEXT",
    						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},
    				}
    			}}
        	},

        	-- TEXT
        	{
				id = l_effectBtnNumLayers,

       			layerType	= UI.LAYER_TEXT,

       			formatInfoSz= { 1, 1 },
       			formatFlags	= FONT.TF_NOCLIP + FONT.TF_SINGLELINE,
       			font =
        		{
    				fontName = "Small", 
       			},
				text = "^login_btnQuit",
        	}, 
        }
    },

    layers =
    {
        MAIN_EFFECT		= 0,
        DEBUG			= 1,
        TEXT			= 2,
    },

    effectInfo =
    {
    	main =
    	{
    		animationIdle 		= "idle",
    		animationSelect		= "over",
    		animationPressed	= "press",
    		animationDisabled	= "idle",
    	},
    }
}

-- ------------------------------------------------------------------------
-- UI.Login_PrivacyPolicyBtn
-- ------------------------------------------------------------------------

UI.Login_PrivacyPolicyBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_BigBtn",

    	props =
    	{
    		name = "Login_PrivacyPolicyBtn",
    	},
	},

	textId = "login_btnPrivacyPolicy",
}

-- ------------------------------------------------------------------------
-- UI.Login_TermsOfUseBtn
-- ------------------------------------------------------------------------

UI.Login_TermsOfUseBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_BigBtn",

    	props =
    	{
    		name = "Login_TermsOfUseBtn",
    	},
	},

	textId = "login_btnTermsOfUse",
}


-- ------------------------------------------------------------------------
-- UI.Login_RememberCheckBox
-- ------------------------------------------------------------------------

local l_numCheckBoxBaseLayers = UI:GetTableLength( UI.EffectCheckBoxWnd.layers )

UI.Login_RememberCheckBox =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "EffectCheckBoxWnd",

    	props =
    	{
    		name		= "Login_RememberCheckBox",
			selectSound	= lw.sounds.btnMouseOver,
			clickSound	= lw.sounds.checkBox,
    	},

    	layers =
    	{
			numLayers = l_numCheckBoxBaseLayers + 1,

    		-- MAIN_EFFECT
    		{
    			layerType	= UI.LAYER_EFFECT,
    			layerStyle	= UI.WLS_RESIZABLE,
    			main		= true,

    			effects =
    			{{
    				defName				= "login_rememberCheckBox",

    				links =
    				{
    					{
    						objName		= "self",
    						animParams	= UI.EffectAnimParams.SIZE,
    					},

    					{
    						objName		= "value",
    						layer		= "UI.Login_RememberCheckBox.layers.TEXT",
    						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},
    				}
    			}}
    		},

    		-- TEXT
    		{
				id			= l_numCheckBoxBaseLayers,

    			layerType	= UI.LAYER_TEXT,

       			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
       			formatInfoSz = { 1, 1 },
       			font =
    			{
       				fontName = "Small",
       			},
    			text = "^login_rememberAccount",
    		},   
    	}	
    },

	layers =
	{
		MAIN_EFFECT		= 0,
		DEBUG			= 1,
		TEXT			= 2,
	},

    effectInfo =
    {
    	main_unchecked =
    	{
    		animationIdle 		= "idle",
    		animationSelect		= "idle_over",
    		animationPressed	= "idle_over",
    		animationDisabled	= "disable",
    	},

    	main_checked =
    	{
    		animationIdle 		= "chek",
    		animationSelect		= "chek_over",
    		animationPressed	= "chek_over",
    		animationDisabled	= "disable_chek",
    	},
    },

	tooltipData =
	{
		tooltipType	= UI.tooltipTypes.TEXT_LARGE,
		caption		= UI:GetStringByName( "login_rememberAccount_tooltipCaption" ),
		text		= UI:GetStringByName( "login_rememberAccount_tooltipText" )
	},
	

	GetTooltipData = function( self )
		return self.tooltipData
	end,
}

-- ---------------------------------------------------------------------------
-- UI.Login_WaitingWnd
-- ---------------------------------------------------------------------------

UI.Login_WaitingWnd =
{
	def =
	{
		className	= "Wnd",
		prototype	= "WaitingWnd",

		props =
		{
			name = "waitingWnd"
		},

    	layers =
    	{
    		-- MAIN_EFFECT
    		{
    			layerType	= UI.LAYER_EFFECT,
    			layerStyle	= UI.WLS_RESIZABLE,
    			main		= true,

    			effects =
    			{{
    				defName				= "login_waiting",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "loading",
    						layer		= "UI.WaitingWnd.layers.PROGRESS_EFFECT",
    						animParams	= UI.EffectAnimParams.POS,
    					},
    				}
    			}}
    		}, 
		}
	}
}

-- ---------------------------------------------------------------------------
-- UI.Login_ServersComboBox
-- ---------------------------------------------------------------------------

UI.Login_ServersComboBox =
{
	def =
	{
		className	= "Wnd",
		prototype	= "ComboBox1",

		props =
		{
			name		= "Login_ServersComboBox"
		},
	},

	MAX_VISIBLE_RECORDS = 5
}

-- ------------------------------------------------------------
-- UI.Login_ConnectingWnd
-- ------------------------------------------------------------

UI.Login_ConnectingWnd = {}

-- -------------------------------
-- window definition
-- -------------------------------

UI.Login_ConnectingWnd.def =
{
	className = "Wnd",

	props =
	{
		name	= "Login_ConnectingWnd",
		style	= UI.WS_UPDATE_IF_VISIBLE,
		rectAbs	= Quat( 0, 0, 1024, 768 ),
	},

	layers =
	{
		-- MAIN_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,
			main		= true,

			effects =
			{{
				defName				= "login_connecting_main",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "login_wait",
						layer		= "UI.Login_ConnectingWnd.layers.WORK_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "blackout_2",
						layer		= "UI.Login_ConnectingWnd.layers.BG_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},
				}
			}}
		},

		-- BG_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "blackBg",
				defaultAnimation    = "idle",
			}}
		},

		-- WORK_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_connecting_work",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "text_1",
						layer		= "UI.Login_ConnectingWnd.layers.DESC",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "text_2",
						layer		= "UI.Login_ConnectingWnd.layers.POS_IN_QUEUE",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "text_3",
						layer		= "UI.Login_ConnectingWnd.layers.TIME_LEFT",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "button_1",
						wnd			= "UI.Login_Connecting_CancelBtn",
						animParams	= UI.EffectAnimParams.POS,
					},
				}
			}}
		},

		-- DESC
		{
			layerType		= UI.LAYER_TEXT,

   			formatFlags	 	= FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz	= { 1, 1 },
   			font			= {fontName = "Small" },
			text			= "^login_connecting_desc",
		}, 

		-- POS_IN_QUEUE
		{
			layerType		= UI.LAYER_TEXT,

   			formatFlags	 	= FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz	= { 1, 1 },
   			font			= {fontName = "Small" },
		}, 

		-- TIME_LEFT
		{
			layerType		= UI.LAYER_TEXT,

   			formatFlags	 	= FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz	= { 1, 1 },
   			font			= {fontName = "Small" },
		}, 
	},

	children = { "UI.Login_Connecting_CancelBtn" }
}

-- -------------------------------
-- interface functions
-- -------------------------------

--
function UI.Login_ConnectingWnd:Setup( position, guesstimate )

	self:UpdatePosInQueue( position )
	self:UpdateTimeLeft( guesstimate )	

end


-- -------------------------------
-- const
-- -------------------------------

UI.Login_ConnectingWnd.layers =
{
    MAIN_EFFECT		= 0,
	BG_EFFECT		= 1,
    WORK_EFFECT		= 2,
    DESC			= 3,
    POS_IN_QUEUE	= 4,
    TIME_LEFT		= 5,
}

-- -------------------------------
-- work functions
-- -------------------------------

--
function UI.Login_ConnectingWnd:Reset()

	self:SetText( "", self.layers.DESC )
	self:SetText( "", self.layers.POS_IN_QUEUE )
	self:SetText( "", self.layers.TIME_LEFT )

end


--
function UI.Login_ConnectingWnd:UpdatePosInQueue( position )

	local str = UI:GetStringByName( "login_connecting_posInQueue" )
	str = string.format( "%s: %d", str, position )

	self:SetText( str, self.layers.POS_IN_QUEUE )
	
end


--
function UI.Login_ConnectingWnd:UpdateTimeLeft( guesstimate )	

	local str = UI:GetStringByName( "login_connecting_timeLeft" )
	local strTime = UI:Time2Str41( guesstimate )
	str = string.format( "%s: %s", str, strTime )

	self:SetText( str, self.layers.TIME_LEFT )

end


-- ------------------------------------------------------------
-- UI.Login_Connecting_CancelBtn
-- ------------------------------------------------------------

UI.Login_Connecting_CancelBtn =
{
	className 	= "ButtonWnd",
	prototype	= "EffectButtonWnd",

    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "EffectButtonWnd",

    	props =
    	{
    		name			= "Login_Connecting_CancelBtn",
			selectSound		= lw.sounds.btnMouseOver,
			clickSound		= lw.sounds.btnClick,
    	},

        layers =
        {
    		numLayers = l_effectBtnNumLayers + 1,

        	-- MAIN_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,
    			main		= true,

    			effects =
    			{{
    				defName				= "login_connecting_cancelBtn",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "self",
    						animParams	= UI.EffectAnimParams.SIZE,
    					},

    					{
    						objName		= "value",
    						layer		= "UI.Login_Connecting_CancelBtn.layers.TEXT",
    						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},
    				}
    			}}
        	},

        	-- TEXT
        	{
				id = l_effectBtnNumLayers,

       			layerType	= UI.LAYER_TEXT,

       			formatInfoSz= { 1, 1 },
       			formatFlags	= FONT.TF_NOCLIP + FONT.TF_SINGLELINE,
       			font =
        		{
    				fontName = "Small", 
       			},
				text = "^login_cancelConnecting",
        	}, 
        }
    },

    layers =
    {
        MAIN_EFFECT		= 0,
        DEBUG			= 1,
        TEXT			= 2,
    },

    effectInfo =
    {
    	main =
    	{
    		animationIdle 		= "idle",
    		animationSelect		= "over",
    		animationPressed	= "press",
    		animationDisabled	= "idle",
    	},
    }
}

-- ------------------------------------------------------------------------
-- UI.Login_SteamLogInBtn
-- ------------------------------------------------------------------------

UI.Login_SteamLogInBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "EffectButtonWnd",

    	props =
    	{
    		name			= "Login_SteamLogInBtn",
			selectSound		= lw.sounds.btnMouseOver,
			clickSound		= lw.sounds.btnClick,
    	},

        layers =
        {
    		numLayers = l_effectBtnNumLayers + 1,

        	-- MAIN_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,
    			main		= true,

    			effects =
    			{{
    				defName				= "login_steamLogInBtn",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "self",
    						animParams	= UI.EffectAnimParams.SIZE,
    					},

    					{
    						objName		= "value",
    						layer		= "UI.Login_SteamLogInBtn.layers.TEXT",
    						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},
    				}
    			}}
        	},

        	-- TEXT
        	{
				id = l_effectBtnNumLayers,

       			layerType	= UI.LAYER_TEXT,

       			formatInfoSz= { 1, 1 },
       			formatFlags	= FONT.TF_NOCLIP + FONT.TF_SINGLELINE,
       			font =
        		{
    				fontName = "Small", 
       			},
				text = "^login_btnLogin",
        	}, 
        }
    },

    layers =
    {
        MAIN_EFFECT		= 0,
        DEBUG			= 1,
        TEXT			= 2,
    },

    effectInfo =
    {
    	main =
    	{
    		animationIdle 		= "idle",
    		animationSelect		= "over",
    		animationPressed	= "press",
    		animationDisabled	= "disable",
    	},
    }
}

-- ------------------------------------------------------------------------
-- UI.Login_ArcLogInBtn
-- ------------------------------------------------------------------------

UI.Login_ArcLogInBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "EffectButtonWnd",

    	props =
    	{
    		name			= "Login_ArcLogInBtn",
			selectSound		= lw.sounds.btnMouseOver,
			clickSound		= lw.sounds.btnClick,
    	},

        layers =
        {
    		numLayers = l_effectBtnNumLayers + 1,

        	-- MAIN_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,
    			main		= true,

    			effects =
    			{{
    				defName				= "login_steamLogInBtn",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "self",
    						animParams	= UI.EffectAnimParams.SIZE,
    					},

    					{
    						objName		= "value",
    						layer		= "UI.Login_ArcLogInBtn.layers.TEXT",
    						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},
    				}
    			}}
        	},

        	-- TEXT
        	{
				id = l_effectBtnNumLayers,

       			layerType	= UI.LAYER_TEXT,

       			formatInfoSz= { 1, 1 },
       			formatFlags	= FONT.TF_NOCLIP + FONT.TF_SINGLELINE,
       			font =
        		{
    				fontName = "Small", 
       			},
				text = "^login_btnLogin",
        	}, 
        }
    },

    layers =
    {
        MAIN_EFFECT		= 0,
        DEBUG			= 1,
        TEXT			= 2,
    },

    effectInfo =
    {
    	main =
    	{
    		animationIdle 		= "idle",
    		animationSelect		= "over",
    		animationPressed	= "press",
    		animationDisabled	= "disable",
    	},
    }
}

-- ------------------------------------------------------------------------
-- UI.Login_SteamImportAccountWnd
-- ------------------------------------------------------------------------

UI.Login_SteamImportAccountWnd = {}

-- ---------------------------------------------
-- window definition
-- ---------------------------------------------

UI.Login_SteamImportAccountWnd.def =
{
	className	= "Wnd",

	props =
	{
		name	= "Login_SteamImportAccountWnd",
		style	= UI.WS_UPDATE_IF_VISIBLE + UI.WS_REDIRECT_ACTIVATION_TO_CHILDREN,
		rectAbs	= Quat( 0, 0, 1024, 768 ),
	},

	layers =
	{
    	-- MAIN_EFFECT
    	{
    		layerType	= UI.LAYER_EFFECT,
    		layerStyle	= UI.WLS_RESIZABLE,
			main		= true,

			effects =
			{{
				defName				= "login_importAccount_main",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "bg",
						layer		= "UI.Login_SteamImportAccountWnd.layers.BG_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "win",
						layer		= "UI.Login_SteamImportAccountWnd.layers.WORK_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},
				}
			}}
		},

    	-- BG_EFFECT
    	{
    		layerType	= UI.LAYER_EFFECT,
    		layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "blackBg",
				defaultAnimation    = "idle",
			}}
		},

    	-- WORK_EFFECT
    	{
    		layerType	= UI.LAYER_EFFECT,
    		layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_importAccount_work",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "title",
						layer		= "UI.Login_SteamImportAccountWnd.layers.CAPTION",
						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "text",
						layer		= "UI.Login_SteamImportAccountWnd.layers.MSG",
						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "login_slot1",
						layer		= "UI.Login_SteamImportAccountWnd.layers.ACCOUNT_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "login_slot2",
						layer		= "UI.Login_SteamImportAccountWnd.layers.PASSWORD_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "registr",
						wnd			= "UI.Login_SteamImportAccount_RegisterBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "forgot",
						wnd			= "UI.Login_SteamImportAccount_ForgetBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "btn_1",
						wnd			= "UI.Login_SteamImportAccount_ImportBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "btn_2",
						wnd			= "UI.Login_SteamImportAccount_CancelBtn",
						animParams	= UI.EffectAnimParams.POS,
					},
				}
			}}
    	},

    	-- CAPTION
    	{
   			layerType	= UI.LAYER_TEXT,

   			formatInfoSz= { 1, 1 },
   			formatFlags	= FONT.TF_NOCLIP + FONT.TF_SINGLELINE,
   			font =
    		{
				fontName = "Small", 
   			},
			text = UI:GetStringByName( "login_import_caption" ),
    	}, 

    	-- MSG
    	{
   			layerType	= UI.LAYER_TEXT,

   			formatInfoSz= { 1, 1 },
   			formatFlags	= FONT.TF_WORDBREAK,
   			font =
    		{
				fontName = "Small", 
   			},
			text = UI:GetStringByName( "login_import_msg" ),
    	}, 

		-- ACCOUNT_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_inputSlot",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "name",
						layer		= "UI.Login_SteamImportAccountWnd.layers.ACCOUNT_LABEL",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "login_input",
						wnd			= "UI.Login_SteamImportAccount_AccountEditWnd",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.ALPHA,
					},
				}
			}}
		},

		-- ACCOUNT_LABEL
		{
			layerType	= UI.LAYER_TEXT,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
			text = "^login_accountLabel",
		}, 

		-- PASSWORD_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_inputSlot",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "name",
						layer		= "UI.Login_SteamImportAccountWnd.layers.PASSWORD_LABEL",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "login_input",
						wnd			= "UI.Login_SteamImportAccount_PasswordEditWnd",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.ALPHA,
					},
				}
			}}
		}, 

		-- PASSWORD_LABEL
		{
			layerType	= UI.LAYER_TEXT,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
			text = "^login_passwordLabel",
		}, 
	},

	children =
	{
		"UI.Login_SteamImportAccount_AccountEditWnd",
		"UI.Login_SteamImportAccount_PasswordEditWnd",
		"UI.Login_SteamImportAccount_ForgetBtn",
		"UI.Login_SteamImportAccount_RegisterBtn",
		"UI.Login_SteamImportAccount_ImportBtn",
		"UI.Login_SteamImportAccount_CancelBtn",
	}
}

-- --------------------------------------
-- interface functions
-- --------------------------------------

--
function UI.Login_SteamImportAccountWnd:Reset()

	UI.Login_SteamImportAccount_AccountEditWnd:SetEditText( "" )
	UI.Login_SteamImportAccount_PasswordEditWnd:SetEditText( "" )

end


--
function UI.Login_SteamImportAccountWnd:OnEditMissMouse( editWnd )

	UI.LoginWnd:OnEditMissMouse( editWnd )

end


-- --------------------------------------
-- const
-- --------------------------------------

UI.Login_SteamImportAccountWnd.layers =
{
    MAIN_EFFECT			= 0,
    BG_EFFECT			= 1,
    WORK_EFFECT			= 2,
    CAPTION				= 3,
    MSG					= 4,
    ACCOUNT_EFFECT		= 5,
    ACCOUNT_LABEL		= 6,
    PASSWORD_EFFECT		= 7,
    PASSWORD_LABEL		= 8,
}

-- --------------------------------------
-- work functions
-- --------------------------------------

--
function UI.Login_SteamImportAccountWnd:F_OnKeyboardKeyDown( key, wndThatReceivedInput )

	if key ~= UI.Keys.KEY_TAB then
    	if self:OnKeyboardKeyDown( key, wndThatReceivedInput ) then
    		return true
    	end
	end
		
	return self:HandleKey( key, -2 )	

end


--
function UI.Login_SteamImportAccountWnd:OnTab()

	return false
	
end

-- ------------------------------------------------------------------------
-- UI.Login_SteamImportAccount_RegisterBtn
-- ------------------------------------------------------------------------

UI.Login_SteamImportAccount_RegisterBtn =
{
	def =
	{
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_SteamImportAccount_RegisterBtn",
    	},
	},

	textId = "login_btnRegister",
}

-- ------------------------------------------------------------------------
-- UI.Login_SteamImportAccount_ForgetBtn
-- ------------------------------------------------------------------------

UI.Login_SteamImportAccount_ForgetBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_SteamImportAccount_ForgetBtn",
    	},
	},

	textId = "login_btnForget",
}

-- ------------------------------------------------------------------------
-- UI.Login_SteamImportAccount_AccountEditWnd, UI.Login_SteamImportAccount_PasswordEditWnd
-- ------------------------------------------------------------------------

--
UI.Login_SteamImportAccount_AccountEditWnd =
{
    def =
    {   	
     	className	= "EditWnd",
    	prototype	= "Login_EditWnd",

     	props =
     	{
     		name		= "Login_SteamImportAccount_AccountEditWnd",
    		symbolsLimit= 123,
    	}
    }
}


--
UI.Login_SteamImportAccount_PasswordEditWnd =
{
    def =
    {   	
     	className	= "EditWnd",
    	prototype	= "Login_EditWnd",

     	props =
     	{
     		name			= "Login_SteamImportAccount_PasswordEditWnd",
			editStyle		= UI.ES_SELECT_ON_FOCUS + UI.ES_AUTOSCROLL + UI.ES_PASS,
    		symbolsLimit	= 127,
    	}
    }
}

-- ------------------------------------------------------------------------
-- UI.Login_ImportAccount_Btn
-- ------------------------------------------------------------------------

UI.Login_ImportAccount_Btn = {}

-- -----------------------------------
-- window definition
-- -----------------------------------

UI.Login_ImportAccount_Btn.def =
{
	className 	= "ButtonWnd",
	prototype	= "Login_Btn",

	props =
	{
		name			= "Login_ImportAccount_Btn",
		isPrototype		= true,
	},

    layers =
    {
    	-- MAIN_EFFECT
    	{
    		layerType	= UI.LAYER_EFFECT,
    		layerStyle	= UI.WLS_RESIZABLE,
			main		= true,

			effects =
			{{
				defName				= "login_importBtn",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "self",
						animParams	= UI.EffectAnimParams.SIZE,
					},

					{
						objName		= "text",
						layer		= "UI.Login_ImportAccount_Btn.layers.TEXT",
						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},
				}
			}}
    	},
    }
}

-- ------------------------------------------------------------------------
-- UI.Login_SteamImportAccount_ImportBtn
-- ------------------------------------------------------------------------

UI.Login_SteamImportAccount_ImportBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_ImportAccount_Btn",

    	props =
    	{
    		name			= "Login_SteamImportAccount_ImportBtn",
    	},
	},

	textId = "login_import_importBtn",
}

-- ------------------------------------------------------------------------
-- UI.Login_SteamImportAccount_CancelBtn
-- ------------------------------------------------------------------------

UI.Login_SteamImportAccount_CancelBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_ImportAccount_Btn",

    	props =
    	{
    		name			= "Login_SteamImportAccount_CancelBtn",
    	},
	},

	textId = "login_import_cancelBtn",
}

-- ------------------------------------------------------------------------
-- UI.Login_ArcImportAccountWnd
-- ------------------------------------------------------------------------

UI.Login_ArcImportAccountWnd = {}

-- ---------------------------------------------
-- window definition
-- ---------------------------------------------

UI.Login_ArcImportAccountWnd.def =
{
	className	= "Wnd",

	props =
	{
		name	= "Login_ArcImportAccountWnd",
		style	= UI.WS_UPDATE_IF_VISIBLE + UI.WS_REDIRECT_ACTIVATION_TO_CHILDREN,
		rectAbs	= Quat( 0, 0, 1024, 768 ),
	},

	layers =
	{
    	-- MAIN_EFFECT
    	{
    		layerType	= UI.LAYER_EFFECT,
    		layerStyle	= UI.WLS_RESIZABLE,
			main		= true,

			effects =
			{{
				defName				= "login_importAccount_main",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "bg",
						layer		= "UI.Login_ArcImportAccountWnd.layers.BG_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "win",
						layer		= "UI.Login_ArcImportAccountWnd.layers.WORK_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},
				}
			}}
		},

    	-- BG_EFFECT
    	{
    		layerType	= UI.LAYER_EFFECT,
    		layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "blackBg",
				defaultAnimation    = "idle",
			}}
		},

    	-- WORK_EFFECT
    	{
    		layerType	= UI.LAYER_EFFECT,
    		layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_importAccount_work",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "title",
						layer		= "UI.Login_ArcImportAccountWnd.layers.CAPTION",
						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "text",
						layer		= "UI.Login_ArcImportAccountWnd.layers.MSG",
						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "login_slot1",
						layer		= "UI.Login_ArcImportAccountWnd.layers.ACCOUNT_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "login_slot2",
						layer		= "UI.Login_ArcImportAccountWnd.layers.PASSWORD_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "registr",
						wnd			= "UI.Login_ArcImportAccount_RegisterBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "forgot",
						wnd			= "UI.Login_ArcImportAccount_ForgetBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "btn_1",
						wnd			= "UI.Login_ArcImportAccount_ImportBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "btn_2",
						wnd			= "UI.Login_ArcImportAccount_CancelBtn",
						animParams	= UI.EffectAnimParams.POS,
					},
				}
			}}
    	},

    	-- CAPTION
    	{
   			layerType	= UI.LAYER_TEXT,

   			formatInfoSz= { 1, 1 },
   			formatFlags	= FONT.TF_NOCLIP + FONT.TF_SINGLELINE,
   			font =
    		{
				fontName = "Small", 
   			},
			text = UI:GetStringByName( "login_arcImport_caption" ),
    	}, 

    	-- MSG
    	{
   			layerType	= UI.LAYER_TEXT,

   			formatInfoSz= { 1, 1 },
   			formatFlags	= FONT.TF_WORDBREAK,
   			font =
    		{
				fontName = "Small", 
   			},
			text = UI:GetStringByName( "login_arcImport_msg" ),
    	}, 

		-- ACCOUNT_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_inputSlot",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "name",
						layer		= "UI.Login_ArcImportAccountWnd.layers.ACCOUNT_LABEL",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "login_input",
						wnd			= "UI.Login_ArcImportAccount_AccountEditWnd",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.ALPHA,
					},
				}
			}}
		},

		-- ACCOUNT_LABEL
		{
			layerType	= UI.LAYER_TEXT,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
			text = "^login_accountLabel",
		}, 

		-- PASSWORD_EFFECT
		{
			layerType	= UI.LAYER_EFFECT,
			layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_inputSlot",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "name",
						layer		= "UI.Login_ArcImportAccountWnd.layers.PASSWORD_LABEL",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.SIZE + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "login_input",
						wnd			= "UI.Login_ArcImportAccount_PasswordEditWnd",
						animParams	= UI.EffectAnimParams.POS + UI.EffectAnimParams.ALPHA,
					},
				}
			}}
		}, 

		-- PASSWORD_LABEL
		{
			layerType	= UI.LAYER_TEXT,

   			formatFlags	 = FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
   			formatInfoSz = { 1, 1 },
   			font =
			{
   				fontName = "Small",
   			},
			text = "^login_passwordLabel",
		}, 
	},

	children =
	{
		"UI.Login_ArcImportAccount_AccountEditWnd",
		"UI.Login_ArcImportAccount_PasswordEditWnd",
		"UI.Login_ArcImportAccount_ForgetBtn",
		"UI.Login_ArcImportAccount_RegisterBtn",
		"UI.Login_ArcImportAccount_ImportBtn",
		"UI.Login_ArcImportAccount_CancelBtn",
	}
}

-- --------------------------------------
-- interface functions
-- --------------------------------------

--
function UI.Login_ArcImportAccountWnd:Reset()

	UI.Login_ArcImportAccount_AccountEditWnd:SetEditText( "" )
	UI.Login_ArcImportAccount_PasswordEditWnd:SetEditText( "" )

end


--
function UI.Login_ArcImportAccountWnd:OnEditMissMouse( editWnd )

	UI.LoginWnd:OnEditMissMouse( editWnd )

end


-- --------------------------------------
-- const
-- --------------------------------------

UI.Login_ArcImportAccountWnd.layers =
{
    MAIN_EFFECT			= 0,
    BG_EFFECT			= 1,
    WORK_EFFECT			= 2,
    CAPTION				= 3,
    MSG					= 4,
    ACCOUNT_EFFECT		= 5,
    ACCOUNT_LABEL		= 6,
    PASSWORD_EFFECT		= 7,
    PASSWORD_LABEL		= 8,
}

-- --------------------------------------
-- work functions
-- --------------------------------------

--
function UI.Login_ArcImportAccountWnd:F_OnKeyboardKeyDown( key, wndThatReceivedInput )

	if key ~= UI.Keys.KEY_TAB then
    	if self:OnKeyboardKeyDown( key, wndThatReceivedInput ) then
    		return true
    	end
	end
		
	return self:HandleKey( key, -2 )	

end


--
function UI.Login_ArcImportAccountWnd:OnTab()

	return false
	
end

-- ------------------------------------------------------------------------
-- UI.Login_ArcImportAccount_RegisterBtn
-- ------------------------------------------------------------------------

UI.Login_ArcImportAccount_RegisterBtn =
{
	def =
	{
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_ArcImportAccount_RegisterBtn",
    	},
	},

	textId = "login_btnRegister",
}

-- ------------------------------------------------------------------------
-- UI.Login_ArcImportAccount_ForgetBtn
-- ------------------------------------------------------------------------

UI.Login_ArcImportAccount_ForgetBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_ArcImportAccount_ForgetBtn",
    	},
	},

	textId = "login_btnForget",
}

-- ------------------------------------------------------------------------
-- UI.Login_ArcImportAccount_AccountEditWnd, UI.Login_ArcImportAccount_PasswordEditWnd
-- ------------------------------------------------------------------------

--
UI.Login_ArcImportAccount_AccountEditWnd =
{
    def =
    {   	
     	className	= "EditWnd",
    	prototype	= "Login_EditWnd",

     	props =
     	{
     		name		= "Login_ArcImportAccount_AccountEditWnd",
    		symbolsLimit= 123,
    	}
    }
}


--
UI.Login_ArcImportAccount_PasswordEditWnd =
{
    def =
    {   	
     	className	= "EditWnd",
    	prototype	= "Login_EditWnd",

     	props =
     	{
     		name			= "Login_ArcImportAccount_PasswordEditWnd",
			editStyle		= UI.ES_SELECT_ON_FOCUS + UI.ES_AUTOSCROLL + UI.ES_PASS,
    		symbolsLimit	= 127,
    	}
    }
}

-- ------------------------------------------------------------------------
-- UI.Login_ArcImportAccount_ImportBtn
-- ------------------------------------------------------------------------

UI.Login_ArcImportAccount_ImportBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_ImportAccount_Btn",

    	props =
    	{
    		name			= "Login_ArcImportAccount_ImportBtn",
    	},
	},

	textId = "login_arcImport_importBtn",
}

-- ------------------------------------------------------------------------
-- UI.Login_ArcImportAccount_CancelBtn
-- ------------------------------------------------------------------------

UI.Login_ArcImportAccount_CancelBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_ImportAccount_Btn",

    	props =
    	{
    		name			= "Login_ArcImportAccount_CancelBtn",
    	},
	},

	textId = "login_arcImport_cancelBtn",
}

-- ------------------------------------------------------------------------
-- UI.Login_SteamImportAccountBox
-- ------------------------------------------------------------------------

UI.Login_SteamImportAccountBox =
{
    def =
    {
    	className = "Wnd",

    	props =
    	{
    		name		= "Login_SteamImportAccountBox",
    		style		= UI.WS_UPDATE_IF_VISIBLE,
    		rectAbs		= Quat( 0, 0, 1024, 768 ),
    	},

    	layers =
    	{
        	-- MAIN_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,
    			main		= true,

    			effects =
    			{{
    				defName				= "msgBox_main",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "blackout",
    						layer		= "UI.Login_SteamImportAccountBox.layers.BG_EFFECT",
    						animParams	= UI.EffectAnimParams.POS,
    					},

    					{
    						objName		= "window",
    						layer		= "UI.Login_SteamImportAccountBox.layers.WORK_EFFECT",
    						animParams	= UI.EffectAnimParams.POS,
    					},
    				}
    			}}
    		},

        	-- BG_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,

    			effects =
    			{{
    				defName				= "blackBg",
    				defaultAnimation    = "idle",
    			}}
    		},

        	-- WORK_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,

    			effects =
    			{{
    				defName				= "login_importAccountBox_work",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "title",
    						layer		= "UI.Login_SteamImportAccountBox.layers.CAPTION",
    						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},

    					{
    						objName		= "text",
    						layer		= "UI.Login_SteamImportAccountBox.layers.TEXT",
    						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},

    					{
    						objName		= "button_3",
    						wnd			= "UI.Login_SteamImportAccountBox_ImportBtn",
    						animParams	= UI.EffectAnimParams.POS,
    					},

    					{
    						objName		= "button_4",
    						wnd			= "UI.Login_SteamImportAccountBox_CreateBtn",
    						animParams	= UI.EffectAnimParams.POS,
    					},

    					{
    						objName		= "button_5",
    						wnd			= "UI.Login_SteamImportAccountBox_CancelBtn",
    						animParams	= UI.EffectAnimParams.POS,
    					},
    				}
    			}}
    		},

    		-- CAPTION
    		{
    			layerType		= UI.LAYER_TEXT,
       			formatFlags	 	= FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
       			formatInfoSz	= { 1, 1 },
       			font			= { fontName = "Small" },
    			text			= UI:GetStringByName( "login_importBox_caption" ),
    		}, 

    		-- TEXT
    		{
    			layerType		= UI.LAYER_TEXT,
       			formatFlags	 	= FONT.TF_WORDBREAK,
       			formatInfoSz	= { 5, 1 },
       			font			= { fontName = "Small" },
    			text			= UI:GetStringByName( "login_importBox_text" ),
    		}, 
    	},

    	children = { "UI.Login_SteamImportAccountBox_ImportBtn", "UI.Login_SteamImportAccountBox_CreateBtn", "UI.Login_SteamImportAccountBox_CancelBtn" }
    },

	layers =
	{
        MAIN_EFFECT	= 0,
        BG_EFFECT	= 1,
        WORK_EFFECT	= 2,
        CAPTION		= 3,
        TEXT		= 4,
	}
}

-- ------------------------------------------------------------------------
-- UI.Login_SteamImportAccountBox_ImportBtn
-- ------------------------------------------------------------------------

UI.Login_SteamImportAccountBox_ImportBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_ImportAccount_Btn",

    	props =
    	{
    		name			= "Login_SteamImportAccountBox_ImportBtn",
    	},
	},

	textId = "login_importBox_importBtn",
}

-- ------------------------------------------------------------------------
-- UI.Login_SteamImportAccountBox_CreateBtn
-- ------------------------------------------------------------------------

UI.Login_SteamImportAccountBox_CreateBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_ImportAccount_Btn",

    	props =
    	{
    		name			= "Login_SteamImportAccountBox_CreateBtn",
    	},
	},

	textId = "login_importBox_createBtn",
}

-- ------------------------------------------------------------------------
-- UI.Login_SteamImportAccountBox_CancelBtn
-- ------------------------------------------------------------------------

UI.Login_SteamImportAccountBox_CancelBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_SteamImportAccountBox_CancelBtn",
    	},

        layers =
        {
        	-- MAIN_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,
    			main		= true,

    			effects =
    			{{
    				defName				= "msgBox_btn",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "self",
    						animParams	= UI.EffectAnimParams.SIZE,
    					},

    					{
    						objName		= "value",
    						layer		= "UI.Login_SteamImportAccountBox_CancelBtn.layers.TEXT",
    						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},
    				}
    			}}
        	},
        }
    },

    effectInfo =
    {
    	main =
    	{
    		animationIdle 		= "idle",
    		animationSelect		= "over_nofocus",
    		animationPressed	= "press_nofocus",
    		animationDisabled	= "disable",
    	},
    },

	textId = "login_importBox_cancelBtn",
}

-- ------------------------------------------------------------------------
-- UI.Login_ArcImportAccountBox
-- ------------------------------------------------------------------------

UI.Login_ArcImportAccountBox =
{
    def =
    {
    	className = "Wnd",

    	props =
    	{
    		name		= "Login_ArcImportAccountBox",
    		style		= UI.WS_UPDATE_IF_VISIBLE,
    		rectAbs		= Quat( 0, 0, 1024, 768 ),
    	},

    	layers =
    	{
        	-- MAIN_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,
    			main		= true,

    			effects =
    			{{
    				defName				= "msgBox_main",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "blackout",
    						layer		= "UI.Login_ArcImportAccountBox.layers.BG_EFFECT",
    						animParams	= UI.EffectAnimParams.POS,
    					},

    					{
    						objName		= "window",
    						layer		= "UI.Login_ArcImportAccountBox.layers.WORK_EFFECT",
    						animParams	= UI.EffectAnimParams.POS,
    					},
    				}
    			}}
    		},

        	-- BG_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,

    			effects =
    			{{
    				defName				= "blackBg",
    				defaultAnimation    = "idle",
    			}}
    		},

        	-- WORK_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,

    			effects =
    			{{
    				defName				= "login_importAccountBox_work",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "title",
    						layer		= "UI.Login_ArcImportAccountBox.layers.CAPTION",
    						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},

    					{
    						objName		= "text",
    						layer		= "UI.Login_ArcImportAccountBox.layers.TEXT",
    						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},

    					{
    						objName		= "button_3",
    						wnd			= "UI.Login_ArcImportAccountBox_ImportBtn",
    						animParams	= UI.EffectAnimParams.POS,
    					},

    					{
    						objName		= "button_5",
    						wnd			= "UI.Login_ArcImportAccountBox_CancelBtn",
    						animParams	= UI.EffectAnimParams.POS,
    					},
    				}
    			}}
    		},

    		-- CAPTION
    		{
    			layerType		= UI.LAYER_TEXT,
       			formatFlags	 	= FONT.TF_SINGLELINE + FONT.TF_NOCLIP,
       			formatInfoSz	= { 1, 1 },
       			font			= { fontName = "Small" },
    			text			= UI:GetStringByName( "login_arcImportBox_caption" ),
    		}, 

    		-- TEXT
    		{
    			layerType		= UI.LAYER_TEXT,
       			formatFlags	 	= FONT.TF_WORDBREAK,
       			formatInfoSz	= { 5, 1 },
       			font			= { fontName = "Small" },
    			text			= UI:GetStringByName( "login_arcImportBox_text" ),
    		}, 
    	},

    	children = { "UI.Login_ArcImportAccountBox_ImportBtn", "UI.Login_ArcImportAccountBox_CancelBtn" }
    },

	layers =
	{
        MAIN_EFFECT	= 0,
        BG_EFFECT	= 1,
        WORK_EFFECT	= 2,
        CAPTION		= 3,
        TEXT		= 4,
	}
}

-- ------------------------------------------------------------------------
-- UI.Login_ArcImportAccountBox_ImportBtn
-- ------------------------------------------------------------------------

UI.Login_ArcImportAccountBox_ImportBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_ImportAccount_Btn",

    	props =
    	{
    		name			= "Login_ArcImportAccountBox_ImportBtn",
    	},
	},

	textId = "login_arcImportBox_importBtn",
}

-- ------------------------------------------------------------------------
-- UI.Login_ArcImportAccountBox_CancelBtn
-- ------------------------------------------------------------------------

UI.Login_ArcImportAccountBox_CancelBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "Login_Btn",

    	props =
    	{
    		name			= "Login_ArcImportAccountBox_CancelBtn",
    	},

        layers =
        {
        	-- MAIN_EFFECT
        	{
        		layerType	= UI.LAYER_EFFECT,
        		layerStyle	= UI.WLS_RESIZABLE,
    			main		= true,

    			effects =
    			{{
    				defName				= "msgBox_btn",
    				defaultAnimation    = "idle",

    				links =
    				{
    					{
    						objName		= "self",
    						animParams	= UI.EffectAnimParams.SIZE,
    					},

    					{
    						objName		= "value",
    						layer		= "UI.Login_ArcImportAccountBox_CancelBtn.layers.TEXT",
    						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
    					},
    				}
    			}}
        	},
        }
    },

    effectInfo =
    {
    	main =
    	{
    		animationIdle 		= "idle",
    		animationSelect		= "over_nofocus",
    		animationPressed	= "press_nofocus",
    		animationDisabled	= "disable",
    	},
    },

	textId = "login_arcImportBox_cancelBtn",
}

-- ------------------------------------------------------------------------
-- UI.Login_TwoStepAuthorisationWnd
-- ------------------------------------------------------------------------

UI.Login_TwoStepAuthorisationWnd = {}

-- --------------------------------------
-- window definition
-- --------------------------------------

UI.Login_TwoStepAuthorisationWnd.def =
{
	className	= "Wnd",

	props =
	{
		name	= "Login_TwoStepAuthorisationWnd",
		style	= UI.WS_UPDATE_IF_VISIBLE + UI.WS_REDIRECT_ACTIVATION_TO_CHILDREN,
		rectAbs	= Quat( 0, 0, 1024, 768 ),
	},

	layers =
	{
    	-- MAIN_EFFECT
    	{
    		layerType	= UI.LAYER_EFFECT,
    		layerStyle	= UI.WLS_RESIZABLE,
			main		= true,

			effects =
			{{
				defName				= "login_importAccount_main",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "bg",
						layer		= "UI.Login_TwoStepAuthorisationWnd.layers.BG_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "win",
						layer		= "UI.Login_TwoStepAuthorisationWnd.layers.WORK_EFFECT",
						animParams	= UI.EffectAnimParams.POS,
					},
				}
			}}
		},

    	-- BG_EFFECT
    	{
    		layerType	= UI.LAYER_EFFECT,
    		layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "blackBg",
				defaultAnimation    = "idle",
			}}
		},

    	-- WORK_EFFECT
    	{
    		layerType	= UI.LAYER_EFFECT,
    		layerStyle	= UI.WLS_RESIZABLE,

			effects =
			{{
				defName				= "login_twoStepAuthorisation_work",
				defaultAnimation    = "idle",

				links =
				{
					{
						objName		= "title",
						layer		= "UI.Login_TwoStepAuthorisationWnd.layers.CAPTION",
						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "text",
						layer		= "UI.Login_TwoStepAuthorisationWnd.layers.MSG",
						animParams	= UI.EffectAnimParams.SIZE + UI.EffectAnimParams.POS + UI.EffectAnimParams.ALIGNMENT + UI.EffectAnimParams.COLOR + UI.EffectAnimParams.ALPHA + UI.EffectAnimParams.FONT + UI.EffectAnimParams.BLEND,
					},

					{
						objName		= "input",
						wnd			= "UI.Login_TwoStepAuthorisation_KeyEditWnd",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "btn_1",
						wnd			= "UI.Login_TwoStepAuthorisation_OkBtn",
						animParams	= UI.EffectAnimParams.POS,
					},

					{
						objName		= "btn_2",
						wnd			= "UI.Login_TwoStepAuthorisation_CancelBtn",
						animParams	= UI.EffectAnimParams.POS,
					},
				}
			}}
    	},

    	-- CAPTION
    	{
   			layerType	= UI.LAYER_TEXT,

   			formatInfoSz= { 1, 1 },
   			formatFlags	= FONT.TF_NOCLIP + FONT.TF_SINGLELINE,
   			font =
    		{
				fontName = "Small", 
   			},
			text = UI:GetStringByName( "login_twoStepAuthorisation_caption" ),
    	}, 

    	-- MSG
    	{
   			layerType	= UI.LAYER_TEXT,

   			formatInfoSz= { 1, 1 },
   			formatFlags	= FONT.TF_WORDBREAK,
   			font =
    		{
				fontName = "Small", 
   			},
			text = UI:GetStringByName( "login_twoStepAuthorisation_msg" ),
    	}, 
	},

	children =
	{
		"UI.Login_TwoStepAuthorisation_KeyEditWnd",
		"UI.Login_TwoStepAuthorisation_OkBtn",
		"UI.Login_TwoStepAuthorisation_CancelBtn",
	}
}

-- --------------------------------------
-- interface functions
-- --------------------------------------

--
function UI.Login_TwoStepAuthorisationWnd:Reset()

	UI.Login_TwoStepAuthorisation_KeyEditWnd:SetEditText( "" )

end


-- --------------------------------------
-- const
-- --------------------------------------

UI.Login_TwoStepAuthorisationWnd.layers =
{
    MAIN_EFFECT			= 0,
    BG_EFFECT			= 1,
    WORK_EFFECT			= 2,
    CAPTION				= 3,
    MSG					= 4,
}

-- --------------------------------------
-- work functions
-- --------------------------------------

--
function UI.Login_TwoStepAuthorisationWnd:F_OnKeyboardKeyDown( key, wndThatReceivedInput )

	if key ~= UI.Keys.KEY_TAB then
    	if self:OnKeyboardKeyDown( key, wndThatReceivedInput ) then
    		return true
    	end
	end
		
	return self:HandleKey( key, -2 )	

end


--
function UI.Login_TwoStepAuthorisationWnd:OnTab()

	return false
	
end

-- ------------------------------------------------------------------------
-- UI.Login_TwoStepAuthorisation_OkBtn
-- ------------------------------------------------------------------------

UI.Login_TwoStepAuthorisation_OkBtn =
{
	def =
	{
    	className 	= "ButtonWnd",
    	prototype	= "TextBtn2",

    	props =
    	{
    		name			= "Login_TwoStepAuthorisation_OkBtn",
    	},
	},

	textId = "login_twoStepAuthorisation_okBtn",
}

-- ------------------------------------------------------------------------
-- UI.Login_TwoStepAuthorisation_CancelBtn
-- ------------------------------------------------------------------------

UI.Login_TwoStepAuthorisation_CancelBtn =
{
    def =
    {
    	className 	= "ButtonWnd",
    	prototype	= "TextBtn2",

    	props =
    	{
    		name			= "Login_TwoStepAuthorisation_CancelBtn",
    	},
	},

	textId = "login_twoStepAuthorisation_cancelBtn",
}

-- ------------------------------------------------------------------------
-- UI.Login_TwoStepAuthorisation_KeyEditWnd
-- ------------------------------------------------------------------------

UI.Login_TwoStepAuthorisation_KeyEditWnd =
{
    def =
    {   	
     	className	= "EditWnd",
    	prototype	= "Login_EditWnd",

     	props =
     	{
     		name		= "Login_TwoStepAuthorisation_KeyEditWnd",
    		symbolsLimit= -1,
    	}
    }
}
