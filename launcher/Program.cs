using System;
using System.Drawing;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Forms;
using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics;
using System.Net;
using System.Security.Cryptography;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Threading.Tasks;
using Microsoft.Win32;

[assembly: AssemblyTitle("SC Launcher")]
[assembly: AssemblyDescription("Лаунчер Star Conflict Europe - Unofficial Server")]
[assembly: AssemblyCompany("Star Conflict Community")]
[assembly: AssemblyProduct("SC Launcher")]
[assembly: AssemblyVersion("0.7.1.0")]
[assembly: AssemblyFileVersion("0.7.1.0")]

namespace SCCommunitySetup
{
    internal static class Program
    {
        [STAThread]
        private static int Main(string[] args)
        {
            if (args.Length > 0)
                return LauncherMode.Run(args);

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new LauncherForm());
            return 0;
        }
    }

    internal sealed class LauncherForm : Form
    {
        private const string WebsiteUrl = "https://star-conflict-eu-server.mak17.workers.dev";
        private const string DiscordUrl = "https://discord.gg/83YkbJbwxx";
        private readonly Label status = new Label();
        private readonly Button play = new Button();
        private readonly TextBox gamePath = new TextBox();
        private readonly Label newsTitle = new Label();
        private readonly Label newsDate = new Label();
        private readonly Label newsBody = new Label();
        private readonly LinkLabel newsLink = new LinkLabel();
        private readonly Timer newsTimer = new Timer();
        private readonly Timer gameDetectionTimer = new Timer();
        private List<NewsItem> newsItems = new List<NewsItem>();
        private int newsIndex;

        internal LauncherForm()
        {
            Text = SetupForm.ServerName;
            ClientSize = new Size(1020, 650);
            MinimumSize = new Size(900, 600);
            StartPosition = FormStartPosition.CenterScreen;
            Font = new Font("Segoe UI", 9.5F);
            BackColor = Color.FromArgb(5, 12, 20);
            ForeColor = Color.FromArgb(226, 235, 242);
            Icon = LoadIcon();

            Panel top = new Panel { Dock = DockStyle.Top, Height = 150, BackColor = Color.FromArgb(8, 20, 33) };
            Controls.Add(top);
            PictureBox logo = new PictureBox {
                Image = LoadLogo(), SizeMode = PictureBoxSizeMode.Zoom,
                Location = new Point(18, 7), Size = new Size(420, 136)
            };
            top.Controls.Add(logo);
            Label title = new Label {
                Text = "EUROPE", AutoSize = true,
                Font = new Font("Segoe UI Semibold", 20F), ForeColor = Color.FromArgb(226, 235, 242),
                Location = new Point(458, 39)
            };
            top.Controls.Add(title);
            Label subtitle = new Label {
                Text = "COMMUNITY LAUNCHER  •  UNOFFICIAL SERVER", AutoSize = true,
                Font = new Font("Segoe UI Semibold", 10F), ForeColor = Color.FromArgb(72, 202, 235),
                Location = new Point(461, 82)
            };
            top.Controls.Add(subtitle);
            string savedLanguage = GameLanguage.GetConfigured();
            top.Controls.Add(MakeFlagButton("RUSSIAN", "Русский", Flags.Russia(), new Point(900, 18), savedLanguage));
            top.Controls.Add(MakeFlagButton("ENGLISH", "English", Flags.UnitedKingdom(), new Point(952, 18), savedLanguage));

            FlowLayoutPanel links = new FlowLayoutPanel {
                FlowDirection = FlowDirection.LeftToRight, WrapContents = false,
                Location = new Point(22, 162), Size = new Size(976, 38), Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right
            };
            controlsAddLink(links, UiText.T("САЙТ", "WEBSITE"), WebsiteUrl);
            controlsAddLink(links, "DISCORD", DiscordUrl);
            controlsAddLink(links, UiText.T("НАСТРОЙКА", "SETTINGS"), null);
            Controls.Add(links);

            Panel news = new Panel {
                Location = new Point(22, 210), Size = new Size(680, 305),
                Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right,
                BackColor = Color.FromArgb(10, 26, 40)
            };
            Controls.Add(news);
            news.Controls.Add(new Label {
                Text = UiText.T("ПОСЛЕДНИЕ НОВОСТИ", "LATEST NEWS"), AutoSize = true,
                Font = new Font("Segoe UI Semibold", 14F), ForeColor = Color.White,
                Location = new Point(20, 17)
            });
            newsTitle.Font = new Font("Segoe UI Emoji", 12F, FontStyle.Bold); // this font draws emoji (monochrome); plain Segoe UI shows boxes
            newsTitle.ForeColor = Color.FromArgb(225, 235, 243);
            newsTitle.Location = new Point(22, 60); newsTitle.Size = new Size(600, 27);
            newsTitle.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            news.Controls.Add(newsTitle);
            newsDate.Font = new Font("Segoe UI", 9F);
            newsDate.ForeColor = Color.FromArgb(103, 151, 180);
            newsDate.Location = new Point(22, 89); newsDate.Size = new Size(600, 22);
            newsDate.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            news.Controls.Add(newsDate);
            newsBody.Font = new Font("Segoe UI Emoji", 10F);
            newsBody.ForeColor = Color.FromArgb(190, 207, 222);
            newsBody.Location = new Point(22, 116); newsBody.Size = new Size(636, 140);
            newsBody.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            news.Controls.Add(newsBody);
            newsLink.Text = UiText.T("ПОДРОБНЕЕ", "READ MORE");
            newsLink.LinkColor = Color.FromArgb(70, 188, 235);
            newsLink.ActiveLinkColor = Color.White;
            newsLink.Location = new Point(22, 260); newsLink.Size = new Size(150, 24);
            newsLink.Anchor = AnchorStyles.Bottom | AnchorStyles.Left;
            newsLink.LinkClicked += delegate { OpenCurrentNews(); };
            news.Controls.Add(newsLink);
            newsTimer.Interval = 8000;
            newsTimer.Tick += delegate {
                if (newsItems.Count == 0) return;
                newsIndex = (newsIndex + 1) % newsItems.Count;
                ShowNewsItem();
            };

            Panel side = new Panel {
                Location = new Point(720, 210), Size = new Size(278, 305),
                Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Right,
                BackColor = Color.FromArgb(10, 26, 40)
            };
            Controls.Add(side);
            side.Controls.Add(new Label { Text = UiText.T("СЕРВЕР", "SERVER"), AutoSize = true, ForeColor = Color.FromArgb(70, 188, 235), Location = new Point(18, 18) });
            side.Controls.Add(new Label { Text = SetupForm.ServerName, Size = new Size(242, 58), Font = new Font("Segoe UI Semibold", 11F), ForeColor = Color.White, Location = new Point(18, 45) });
            status.Text = UiText.T("Проверка…", "Checking…");
            status.AutoSize = false;
            status.Size = new Size(240, 58);
            status.Location = new Point(18, 116);
            status.ForeColor = Color.FromArgb(150, 170, 190);
            side.Controls.Add(status);
            Button check = MakeButton(UiText.T("ПРОВЕРИТЬ ОБНОВЛЕНИЯ", "CHECK FOR UPDATES"), Color.FromArgb(32, 64, 87));
            check.Location = new Point(18, 205); check.Size = new Size(242, 38);
            check.Click += async delegate { await CheckAndApplyAsync(true); };
            side.Controls.Add(check);
            play = MakeButton(UiText.T("ИГРАТЬ", "PLAY"), Color.FromArgb(184, 129, 39));
            play.Location = new Point(18, 251); play.Size = new Size(242, 42);
            play.Click += async delegate { await PlayAsync(); };
            side.Controls.Add(play);

            Label pathCaption = new Label { Text = UiText.T("Папка установленной игры", "Installed game folder"), AutoSize = true, ForeColor = Color.FromArgb(160, 180, 198), Location = new Point(22, 535), Anchor = AnchorStyles.Bottom | AnchorStyles.Left };
            Controls.Add(pathCaption);
            gamePath.Text = SetupForm.FindGamePath();
            gamePath.Location = new Point(25, 559); gamePath.Size = new Size(793, 28);
            gamePath.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            gamePath.BackColor = Color.FromArgb(22, 36, 50); gamePath.ForeColor = Color.White; gamePath.BorderStyle = BorderStyle.FixedSingle;
            gamePath.TextChanged += delegate { RefreshGameState(); };
            Controls.Add(gamePath);
            Button browse = MakeButton(UiText.T("ОБЗОР…", "BROWSE…"), Color.FromArgb(32, 64, 87));
            browse.Location = new Point(834, 557); browse.Size = new Size(164, 32); browse.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
            browse.Click += delegate { Browse(); };
            Controls.Add(browse);
            Label steamHint = new Label {
                Text = UiText.T("Запуск через Steam: строка для параметров запуска — в «Настройка»", "Launch from Steam: the launch options line is in Settings"), AutoSize = true,
                ForeColor = Color.FromArgb(110, 146, 168), Location = new Point(22, 614), Anchor = AnchorStyles.Bottom | AnchorStyles.Left
            };
            Controls.Add(steamHint);
            gameDetectionTimer.Interval = 5000;
            gameDetectionTimer.Tick += delegate { DetectInstalledGame(); };
            Activated += delegate { DetectInstalledGame(); };
            Shown += async delegate {
                RefreshGameState();
                gameDetectionTimer.Start();
                if (IsGameAvailable()) await Task.WhenAll(CheckAndApplyAsync(false), LoadNewsAsync());
                else await LoadNewsAsync();
            };
        }

        private async Task LoadNewsAsync()
        {
            try { newsItems = await Task.Run(() => NewsService.Load()); }
            catch { newsItems = NewsService.Fallback(); }
            if (newsItems == null || newsItems.Count == 0) newsItems = NewsService.Fallback();
            newsIndex = 0;
            ShowNewsItem();
            newsTimer.Start();
        }

        private void ShowNewsItem()
        {
            NewsItem item = newsItems[newsIndex];
            newsTitle.Text = item.Title ?? String.Empty;
            newsDate.Text = item.Date ?? String.Empty;
            newsBody.Text = item.Summary ?? String.Empty;
            newsLink.Visible = !String.IsNullOrWhiteSpace(item.Url);
        }

        private void OpenCurrentNews()
        {
            if (newsItems.Count == 0) return;
            Uri uri;
            if (Uri.TryCreate(newsItems[newsIndex].Url, UriKind.Absolute, out uri) && uri.Scheme == Uri.UriSchemeHttps)
                Process.Start(new ProcessStartInfo(uri.AbsoluteUri) { UseShellExecute = true });
        }

        private void controlsAddLink(FlowLayoutPanel panel, string text, string url)
        {
            Button button = MakeButton(text, Color.FromArgb(10, 26, 40));
            button.Size = new Size(140, 32);
            if (url == null) button.Click += delegate { using (SetupForm setup = new SetupForm()) setup.ShowDialog(this); };
            else button.Click += delegate { Process.Start(new ProcessStartInfo(url) { UseShellExecute = true }); };
            panel.Controls.Add(button);
        }

        private Button MakeFlagButton(string value, string name, Image flag, Point location, string current)
        {
            bool selected = value == current;
            Button button = new Button {
                Image = flag, Location = location, Size = new Size(46, 32), FlatStyle = FlatStyle.Flat,
                BackColor = Color.FromArgb(8, 20, 33), Cursor = selected ? Cursors.Default : Cursors.Hand,
                Anchor = AnchorStyles.Top | AnchorStyles.Right, TabStop = false
            };
            button.FlatAppearance.BorderSize = 2;
            button.FlatAppearance.BorderColor = selected ? Color.FromArgb(72, 202, 235) : Color.FromArgb(8, 20, 33);
            new ToolTip().SetToolTip(button, name);
            if (!selected)
                button.Click += delegate {
                    LauncherSettings.Set("Language", value);
                    GameLanguage.Apply(value);
                    BeginInvoke(new Action(delegate { Application.Restart(); }));
                };
            return button;
        }

        private static Button MakeButton(string text, Color color)
        {
            Button button = new Button { Text = text, BackColor = color, ForeColor = Color.White, FlatStyle = FlatStyle.Flat, Cursor = Cursors.Hand };
            button.FlatAppearance.BorderSize = 1;
            button.FlatAppearance.BorderColor = Color.FromArgb(35, 83, 108);
            button.Font = new Font("Segoe UI Semibold", 9F);
            return button;
        }

        private void Browse()
        {
            using (FolderBrowserDialog dialog = new FolderBrowserDialog())
            {
                dialog.Description = UiText.T("Выберите папку Star Conflict", "Select the Star Conflict folder");
                dialog.SelectedPath = gamePath.Text;
                if (dialog.ShowDialog(this) == DialogResult.OK)
                {
                    gamePath.Text = dialog.SelectedPath;
                    RefreshGameState();
                }
            }
        }

        private bool IsGameAvailable()
        {
            try
            {
                string root = Path.GetFullPath(gamePath.Text.Trim());
                return SetupForm.IsGameFolder(root) && File.Exists(Path.Combine(root, @"win64\game.exe"));
            }
            catch { return false; }
        }

        private void RefreshGameState()
        {
            bool available = IsGameAvailable();
            play.Text = available ? UiText.T("ИГРАТЬ", "PLAY") : UiText.T("УСТАНОВИТЬ ИГРУ", "INSTALL GAME");
            if (!available)
            {
                status.ForeColor = Color.FromArgb(231, 177, 92);
                status.Text = UiText.T("ИГРА НЕ УСТАНОВЛЕНА", "GAME IS NOT INSTALLED");
            }
        }

        private void DetectInstalledGame()
        {
            if (IsGameAvailable())
            {
                RefreshGameState();
                return;
            }

            string detected = SetupForm.FindGamePath();
            if (SetupForm.IsGameFolder(detected) && File.Exists(Path.Combine(detected, @"win64\game.exe")))
                gamePath.Text = detected;
            RefreshGameState();
        }

        private void InstallGameThroughSteam()
        {
            try
            {
                Process.Start(new ProcessStartInfo("steam://install/212070") { UseShellExecute = true });
                status.ForeColor = Color.FromArgb(70, 188, 235);
                status.Text = UiText.T("ОТКРЫТ STEAM. ПОДТВЕРДИТЕ УСТАНОВКУ", "STEAM OPENED. CONFIRM INSTALLATION");
                MessageBox.Show(this,
                    UiText.T("В Steam открыто окно установки Star Conflict. Подтвердите установку. Лаунчер автоматически обнаружит игру после загрузки.", "Steam has opened the Star Conflict installation dialog. Confirm installation. The launcher will detect the game automatically when the download is complete."),
                    UiText.T("Установка Star Conflict", "Install Star Conflict"),
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show(this, ex.Message, UiText.T("Не удалось открыть Steam", "Could not open Steam"), MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private async Task CheckAndApplyAsync(bool showResult)
        {
            if (!IsGameAvailable())
            {
                RefreshGameState();
                if (showResult)
                    MessageBox.Show(this, UiText.T("Star Conflict не установлен. Нажмите «Установить игру».", "Star Conflict is not installed. Click INSTALL GAME."), UiText.T("Игра не найдена", "Game not found"), MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }
            play.Enabled = false;
            status.Text = UiText.T("Проверяем пресет и моды…", "Checking preset and mods…");
            try
            {
                string root = Path.GetFullPath(gamePath.Text.Trim());
                string updateResult = await Task.Run(() => {
                    GameLanguage.ApplyConfigured();
                    LauncherMode.EnsurePreset(root);
                    return ModUpdater.ApplyConfigured(root);
                });
                status.ForeColor = Color.FromArgb(89, 205, 124);
                status.Text = String.IsNullOrEmpty(updateResult) ? UiText.T("ГОТОВО К ЗАПУСКУ", "READY TO PLAY") : updateResult;
                if (showResult) MessageBox.Show(this, status.Text, UiText.T("Проверка завершена", "Check complete"), MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                status.ForeColor = Color.FromArgb(231, 119, 105);
                status.Text = UiText.T("ТРЕБУЕТСЯ ВНИМАНИЕ", "ATTENTION REQUIRED");
                if (showResult) MessageBox.Show(this, ex.Message, UiText.T("Ошибка проверки", "Check failed"), MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally { play.Enabled = true; }
        }

        private async Task PlayAsync()
        {
            if (!IsGameAvailable())
            {
                InstallGameThroughSteam();
                return;
            }
            await CheckAndApplyAsync(false);
            try
            {
                string root = Path.GetFullPath(gamePath.Text.Trim());
                string gameExecutable = Path.Combine(root, @"win64\game.exe");
                if (!File.Exists(gameExecutable))
                    throw new FileNotFoundException(UiText.T("Не найден исполняемый файл Star Conflict", "Star Conflict executable was not found"), gameExecutable);
                ProcessStartInfo wrapper = new ProcessStartInfo();
                wrapper.FileName = Application.ExecutablePath;
                wrapper.Arguments = LauncherMode.QuoteArgument(gameExecutable);
                wrapper.WorkingDirectory = AppDomain.CurrentDomain.BaseDirectory;
                wrapper.UseShellExecute = false;
                Process.Start(wrapper);
                Close();
            }
            catch (Exception ex) { MessageBox.Show(this, ex.Message, UiText.T("Не удалось запустить игру", "Could not start the game"), MessageBoxButtons.OK, MessageBoxIcon.Error); }
        }

        private static Image LoadLogo()
        {
            Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("SCLogo.png");
            if (stream == null) return null;
            using (stream) using (Image image = Image.FromStream(stream)) return new Bitmap(image);
        }

        private static Icon LoadIcon()
        {
            Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("SCAppIcon.ico");
            if (stream == null) return SystemIcons.Application;
            using (stream) using (Icon icon = new Icon(stream)) return (Icon)icon.Clone();
        }
    }

    internal sealed class SetupForm : Form
    {
        internal const string ServerName = "Star Conflict Europe - Unofficial Server";
        internal const string ServerAddress = "57.131.200.242:3801";
        internal const string Marker = "-- SC Community Server Preset v0.6.5";

        private readonly TextBox gamePath = new TextBox();
        private readonly TextBox log = new TextBox();
        private readonly Button primaryAction = new Button();

        public SetupForm()
        {
            Text = ServerName + UiText.T(" — настройки", " — settings");
            ClientSize = new Size(850, 647);
            MinimumSize = new Size(740, 612);
            StartPosition = FormStartPosition.CenterScreen;
            Font = new Font("Segoe UI", 9.5F);
            AutoScaleMode = AutoScaleMode.Dpi;
            BackColor = Color.FromArgb(12, 18, 27);
            ForeColor = Color.FromArgb(225, 232, 240);
            Icon = LoadAppIcon();

            Panel header = new Panel();
            header.Dock = DockStyle.Top;
            header.Height = 112;
            header.BackColor = Color.FromArgb(18, 29, 43);
            Controls.Add(header);

            PictureBox logo = new PictureBox();
            logo.Image = LoadLogo();
            logo.SizeMode = PictureBoxSizeMode.Zoom;
            logo.Location = new Point(24, 14);
            logo.Size = new Size(285, 84);
            header.Controls.Add(logo);

            Label heading = new Label();
            heading.Text = "COMMUNITY EDITION";
            heading.Font = new Font("Segoe UI Semibold", 18F);
            heading.ForeColor = Color.White;
            heading.AutoSize = true;
            heading.Location = new Point(333, 28);
            header.Controls.Add(heading);

            Label subtitle = new Label();
            subtitle.Text = UiText.T("Подключение к серверу сообщества", "Community server connection");
            subtitle.Font = new Font("Segoe UI", 10.5F);
            subtitle.ForeColor = Color.FromArgb(143, 165, 188);
            subtitle.AutoSize = true;
            subtitle.Location = new Point(336, 67);
            header.Controls.Add(subtitle);

            Panel serverCard = new Panel();
            serverCard.Location = new Point(24, 134);
            serverCard.Size = new Size(802, 74);
            serverCard.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            serverCard.BackColor = Color.FromArgb(22, 34, 48);
            Controls.Add(serverCard);

            Label serverCaption = new Label();
            serverCaption.Text = UiText.T("СЕРВЕР", "SERVER");
            serverCaption.Font = new Font("Segoe UI Semibold", 8F);
            serverCaption.ForeColor = Color.FromArgb(88, 191, 235);
            serverCaption.AutoSize = true;
            serverCaption.Location = new Point(18, 12);
            serverCard.Controls.Add(serverCaption);

            Label server = new Label();
            server.Text = ServerName;
            server.Font = new Font("Segoe UI Semibold", 12F);
            server.ForeColor = Color.White;
            server.AutoSize = true;
            server.Location = new Point(17, 34);
            serverCard.Controls.Add(server);

            Label address = new Label();
            address.Text = ServerAddress;
            address.Font = new Font("Consolas", 11F);
            address.ForeColor = Color.FromArgb(151, 213, 238);
            address.AutoSize = true;
            address.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            address.Location = new Point(610, 37);
            serverCard.Controls.Add(address);

            Label pathLabel = new Label();
            pathLabel.Text = UiText.T("Папка установленной игры", "Installed game folder");
            pathLabel.ForeColor = Color.FromArgb(185, 199, 213);
            pathLabel.AutoSize = true;
            pathLabel.Location = new Point(24, 226);
            Controls.Add(pathLabel);

            gamePath.Text = FindGamePath();
            gamePath.Location = new Point(27, 250);
            gamePath.Size = new Size(680, 29);
            gamePath.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            gamePath.BackColor = Color.FromArgb(27, 41, 56);
            gamePath.ForeColor = Color.White;
            gamePath.BorderStyle = BorderStyle.FixedSingle;
            Controls.Add(gamePath);

            Button browse = new Button();
            browse.Text = UiText.T("Обзор…", "Browse…");
            browse.Location = new Point(719, 248);
            browse.Size = new Size(107, 33);
            browse.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            StyleSecondaryButton(browse);
            browse.Click += delegate { Browse(); };
            Controls.Add(browse);

            primaryAction.Location = new Point(27, 304);
            primaryAction.Size = new Size(240, 42);
            primaryAction.FlatStyle = FlatStyle.Flat;
            primaryAction.FlatAppearance.BorderSize = 0;
            primaryAction.ForeColor = Color.White;
            primaryAction.Font = new Font("Segoe UI Semibold", 9.5F);
            primaryAction.Cursor = Cursors.Hand;
            primaryAction.Click += delegate { RunAction(!IsInstalled()); };
            Controls.Add(primaryAction);

            Label note = new Label();
            note.Text = UiText.T("Перед установкой полностью закройте игру. Утилита изменяет только адрес сервера и не запрашивает данные учётной записи.", "Close the game before installation. This utility only changes the server address and never requests account credentials.");
            note.ForeColor = Color.FromArgb(143, 165, 188);
            note.Location = new Point(290, 304);
            note.Size = new Size(536, 45);
            note.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            Controls.Add(note);

            log.Multiline = true;
            log.ReadOnly = true;
            log.ScrollBars = ScrollBars.Vertical;
            log.BackColor = Color.FromArgb(8, 14, 22);
            log.ForeColor = Color.FromArgb(166, 214, 232);
            log.BorderStyle = BorderStyle.FixedSingle;
            log.Font = new Font("Consolas", 9F);
            Label steamCaption = new Label();
            steamCaption.Text = UiText.T("ЗАПУСК ЧЕРЕЗ STEAM", "LAUNCH FROM STEAM");
            steamCaption.Font = new Font("Segoe UI Semibold", 8F);
            steamCaption.ForeColor = Color.FromArgb(88, 191, 235);
            steamCaption.AutoSize = true;
            steamCaption.Location = new Point(24, 366);
            Controls.Add(steamCaption);

            Label steamHelp = new Label();
            steamHelp.Text = UiText.T("Steam → Библиотека → Star Conflict → Свойства → Общие → Параметры запуска: вставьте эту строку. Тогда кнопка «Играть» в Steam запускает игру через лаунчер. Если переместите лаунчер, скопируйте строку заново.",
                                      "Steam → Library → Star Conflict → Properties → General → Launch options: paste this line. Steam's Play button then starts the game through the launcher. If you move the launcher, copy the line again.");
            steamHelp.ForeColor = Color.FromArgb(143, 165, 188);
            steamHelp.Location = new Point(24, 388);
            steamHelp.Size = new Size(802, 40);
            steamHelp.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            Controls.Add(steamHelp);

            TextBox steamCommand = new TextBox();
            steamCommand.Text = LauncherMode.QuoteArgument(Application.ExecutablePath) + " %command%";
            steamCommand.ReadOnly = true;
            steamCommand.Font = new Font("Consolas", 9.5F);
            steamCommand.Location = new Point(27, 434);
            steamCommand.Size = new Size(680, 29);
            steamCommand.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            steamCommand.BackColor = Color.FromArgb(27, 41, 56);
            steamCommand.ForeColor = Color.White;
            steamCommand.BorderStyle = BorderStyle.FixedSingle;
            Controls.Add(steamCommand);

            Button copySteam = new Button();
            copySteam.Text = UiText.T("Копировать", "Copy");
            copySteam.Location = new Point(719, 432);
            copySteam.Size = new Size(107, 33);
            copySteam.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            StyleSecondaryButton(copySteam);
            copySteam.Click += delegate {
                Clipboard.SetText(steamCommand.Text);
                copySteam.Text = UiText.T("Скопировано", "Copied");
                WriteLog(UiText.T("Строка для Steam скопирована: ", "Steam line copied: ") + steamCommand.Text);
            };
            Controls.Add(copySteam);

            log.Location = new Point(27, 482);
            log.Size = new Size(799, 137);
            log.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            Controls.Add(log);

            RefreshState();
            WriteLog(UiText.T("Готово к установке. Адрес и порт уже заполнены.", "Ready to install. The address and port are already filled in."));
        }

        private static void StyleSecondaryButton(Button button)
        {
            button.FlatStyle = FlatStyle.Flat;
            button.FlatAppearance.BorderColor = Color.FromArgb(65, 89, 111);
            button.FlatAppearance.BorderSize = 1;
            button.BackColor = Color.FromArgb(26, 40, 55);
            button.ForeColor = Color.FromArgb(220, 229, 237);
            button.Cursor = Cursors.Hand;
        }

        private static Image LoadLogo()
        {
            Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("SCLogo.png");
            if (stream == null) return null;
            using (stream)
            using (Image image = Image.FromStream(stream))
                return new Bitmap(image);
        }

        private static Icon LoadAppIcon()
        {
            Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("SCAppIcon.ico");
            if (stream == null) return SystemIcons.Application;
            using (stream)
            using (Icon icon = new Icon(stream))
                return (Icon)icon.Clone();
        }

        internal static string FindGamePath()
        {
            List<string> candidates = new List<string>();

            // Steam may be installed anywhere, and every library can live on another drive.
            foreach (string steamRoot in FindSteamRoots())
            {
                AddCandidate(candidates, FindGameFromManifest(Path.Combine(steamRoot, "steamapps")));
                AddCandidate(candidates, Path.Combine(steamRoot, @"steamapps\common\star conflict"));

                string librariesFile = Path.Combine(steamRoot, @"steamapps\libraryfolders.vdf");
                if (!File.Exists(librariesFile)) continue;
                try
                {
                    string vdf = File.ReadAllText(librariesFile);
                    foreach (Match match in Regex.Matches(vdf, "\"path\"\\s*\"([^\"]+)\"", RegexOptions.IgnoreCase))
                    {
                        string library = match.Groups[1].Value.Replace(@"\\", @"\");
                        AddCandidate(candidates, FindGameFromManifest(Path.Combine(library, "steamapps")));
                        AddCandidate(candidates, Path.Combine(library, @"steamapps\common\star conflict"));
                    }
                }
                catch { }
            }

            // Fallback for portable Steam installations and systems with missing registry data.
            foreach (DriveInfo drive in DriveInfo.GetDrives())
            {
                if (!drive.IsReady) continue;
                AddCandidate(candidates, Path.Combine(drive.RootDirectory.FullName, @"SteamLibrary\steamapps\common\star conflict"));
            }

            foreach (string path in candidates)
                if (IsGameFolder(path)) return path;

            return candidates.Count > 0 ? candidates[0] : @"C:\Program Files (x86)\Steam\steamapps\common\star conflict";
        }

        private static IEnumerable<string> FindSteamRoots()
        {
            List<string> roots = new List<string>();
            string[] keys = {
                @"HKEY_CURRENT_USER\Software\Valve\Steam",
                @"HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam",
                @"HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam"
            };
            foreach (string key in keys)
            {
                AddCandidate(roots, Convert.ToString(Registry.GetValue(key, "SteamPath", null)));
                AddCandidate(roots, Convert.ToString(Registry.GetValue(key, "InstallPath", null)));
                string exe = Convert.ToString(Registry.GetValue(key, "SteamExe", null));
                if (!String.IsNullOrWhiteSpace(exe)) AddCandidate(roots, Path.GetDirectoryName(exe));
            }
            AddCandidate(roots, @"C:\Program Files (x86)\Steam");
            AddCandidate(roots, @"C:\Program Files\Steam");
            return roots;
        }

        private static string FindGameFromManifest(string steamApps)
        {
            if (!Directory.Exists(steamApps)) return null;
            try
            {
                foreach (string manifest in Directory.GetFiles(steamApps, "appmanifest_*.acf"))
                {
                    string text = File.ReadAllText(manifest);
                    Match appId = Regex.Match(text, "\"appid\"\\s*\"212070\"", RegexOptions.IgnoreCase);
                    Match installDir = Regex.Match(text, "\"installdir\"\\s*\"([^\"]+)\"", RegexOptions.IgnoreCase);
                    if (appId.Success && installDir.Success)
                        return Path.Combine(steamApps, "common", installDir.Groups[1].Value);
                }
            }
            catch { }
            return null;
        }

        private static void AddCandidate(List<string> paths, string path)
        {
            if (String.IsNullOrWhiteSpace(path)) return;
            try
            {
                path = Path.GetFullPath(path.Trim().Trim('"'));
                if (!paths.Exists(p => String.Equals(p, path, StringComparison.OrdinalIgnoreCase))) paths.Add(path);
            }
            catch { }
        }

        internal static bool IsGameFolder(string path)
        {
            if (String.IsNullOrWhiteSpace(path) || !Directory.Exists(path)) return false;
            return File.Exists(Path.Combine(path, @"data\ui\scripts\windows\loginwnd.lua")) &&
                   (File.Exists(Path.Combine(path, "files.list")) || Directory.Exists(Path.Combine(path, "win64")));
        }

        private void Browse()
        {
            using (FolderBrowserDialog dialog = new FolderBrowserDialog())
            {
                dialog.Description = UiText.T("Выберите папку Star Conflict", "Select the Star Conflict folder");
                dialog.SelectedPath = gamePath.Text;
                if (dialog.ShowDialog(this) == DialogResult.OK)
                {
                    gamePath.Text = dialog.SelectedPath;
                    RefreshState();
                }
            }
        }

        private bool IsInstalled()
        {
            try
            {
                string loginFile = Path.Combine(Path.GetFullPath(gamePath.Text.Trim()), @"data\ui\scripts\windows\loginwnd.lua");
                if (!File.Exists(loginFile)) return false;
                string text = File.ReadAllText(loginFile, Encoding.UTF8);
                return text.IndexOf(ServerAddress, StringComparison.Ordinal) >= 0 &&
                       (text.IndexOf(ServerName, StringComparison.Ordinal) >= 0 || text.IndexOf("Star Conflict Europe Unofficial server", StringComparison.Ordinal) >= 0);
            }
            catch { return false; }
        }

        private void RefreshState()
        {
            bool installed = IsInstalled();
            primaryAction.Text = installed ? UiText.T("УДАЛИТЬ МОДИФИКАЦИЮ", "REMOVE MODIFICATION") : UiText.T("УСТАНОВИТЬ", "INSTALL");
            primaryAction.BackColor = installed ? Color.FromArgb(158, 62, 65) : Color.FromArgb(21, 139, 188);
        }

        private void RunAction(bool installing)
        {
            try
            {
                if (IsGameRunning())
                    throw new InvalidOperationException(UiText.T("Сначала полностью закройте Star Conflict.", "Close Star Conflict first."));

                string root = Path.GetFullPath(gamePath.Text.Trim());
                string loginFile = Path.Combine(root, @"data\ui\scripts\windows\loginwnd.lua");
                if (!File.Exists(loginFile))
                    throw new FileNotFoundException(UiText.T("Не найден файл игры", "Game file was not found"), loginFile);

                if (installing) Install(loginFile);
                else Uninstall(root, loginFile);
                RefreshState();
            }
            catch (Exception ex)
            {
                WriteLog(UiText.T("ОШИБКА: ", "ERROR: ") + ex.Message);
                MessageBox.Show(this, ex.Message, UiText.T("Операция не выполнена", "Operation failed"), MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void Install(string loginFile)
        {
            string text = File.ReadAllText(loginFile, Encoding.UTF8);
            if (!Regex.IsMatch(text, @"(?m)^[ \t]*lw\.defaultServers\s*=\s*\r?\n[ \t]*\{\s*\r?\n"))
                throw new InvalidDataException(UiText.T("Структура loginwnd.lua не распознана. Возможно, версия клиента изменилась.", "The loginwnd.lua structure is not supported. The client version may have changed."));

            string backupRoot = CreateBackup(loginFile);
            text = ApplyPreset(text);
            WriteUtf8(loginFile, text);

            RemoveLegacyServerAddress();
            WriteLog(UiText.T("Установлено: ", "Installed: ") + ServerName + " (" + ServerAddress + ").");
            WriteLog(UiText.T("Резервная копия: ", "Backup: ") + backupRoot);
            MessageBox.Show(this, UiText.T("Настройка установлена. При следующем запуске сервер будет выбран автоматически.", "The preset is installed. The server will be selected automatically on the next launch."), UiText.T("Готово", "Done"), MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void Uninstall(string root, string loginFile)
        {
            // Mod files first: loginwnd.lua may be one of them, and the preset cleanup below then runs on the stock file.
            int restoredFiles = ModUpdater.RestoreOriginals(root);
            WriteLog(UiText.T("Возвращено исходных файлов игры: ", "Game files restored: ") + restoredFiles + ".");
            string text = File.ReadAllText(loginFile, Encoding.UTF8);
            string cleaned = RestoreBuiltInServers(RemovePreset(text));
            if (cleaned != text) WriteUtf8(loginFile, cleaned);
            RemoveLegacyServerAddress();
            WriteLog(UiText.T("Настройка сервера удалена.", "Server preset removed."));
            MessageBox.Show(this, UiText.T("Запись Community Server удалена.", "The Community Server entry has been removed."), UiText.T("Готово", "Done"), MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        internal static string RemovePreset(string text)
        {
            text = Regex.Replace(text, @"(?m)^[ \t]*-- SC Community Server Preset v[^\r\n]*\r?\n", "");
            string[] names = {
                ServerName,
                "Star Conflict Community Edition",
                "Star Conflict Europe Unofficial server"
            };
            foreach (string name in names)
            {
                string escapedName = Regex.Escape(name);
                string escapedAddress = Regex.Escape(ServerAddress);
                text = Regex.Replace(text, "(?m)^[ \\t]*\\{[ \\t]*name[ \\t]*=[ \\t]*\\\"" + escapedName + "\\\"[ \\t]*,[ \\t]*address[ \\t]*=[ \\t]*\\\"" + escapedAddress + "\\\"[ \\t]*\\},[ \\t]*\\r?\\n", "");
            }
            return text;
        }

        internal static string ApplyPreset(string text)
        {
            text = RemovePreset(text);
            text = Regex.Replace(text, @"(?m)^[ \t]*\{[ \t]*name[ \t]*=[ \t]*""(localhost|server)""[ \t]*,[ \t]*address[ \t]*=[ \t]*""(localhost)?""[ \t]*\},[ \t]*\r?\n", "");
            string entry = "\t" + Marker + "\r\n\t{ name = \"" + ServerName + "\", address = \"" + ServerAddress + "\" },\r\n";
            Regex listStart = new Regex(@"(?m)^([ \t]*lw\.defaultServers\s*=\s*\r?\n[ \t]*\{\s*\r?\n)");
            if (!listStart.IsMatch(text)) throw new InvalidDataException("Unsupported loginwnd.lua structure");
            return listStart.Replace(text, "$1" + entry, 1);
        }

        internal static string RestoreBuiltInServers(string text)
        {
            text = Regex.Replace(text, @"(?m)^[ \t]*\{[ \t]*name[ \t]*=[ \t]*""(localhost|server)""[ \t]*,[ \t]*address[ \t]*=[ \t]*""(localhost)?""[ \t]*\},[ \t]*\r?\n", "");
            string entries = "\t{ name = \"localhost\", address = \"localhost\" },\r\n\t{ name = \"server\", address = \"\" },\r\n";
            Regex listStart = new Regex(@"(?m)^([ \t]*lw\.defaultServers\s*=\s*\r?\n[ \t]*\{\s*\r?\n)");
            return listStart.Replace(text, "$1" + entries, 1);
        }

        internal static string CreateBackup(string loginFile)
        {
            string state = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), @"Targem\StarConflict\community-server-preset");
            string backup = Path.Combine(state, "backups", DateTime.Now.ToString("yyyyMMdd-HHmmss"));
            Directory.CreateDirectory(backup);
            File.Copy(loginFile, Path.Combine(backup, "loginwnd.lua"), true);
            return backup;
        }

        // The server address comes from loginwnd.lua only: the game drops net_masterServerAddress from
        // user_config.xml on exit. This removes the entry older launcher versions wrote (our address or empty).
        internal static int RemoveLegacyServerAddress()
        {
            string documents = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
            string local = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            string[] paths = {
                Path.Combine(local, @"Targem\StarConflict\user_config.xml"),
                Path.Combine(documents, @"My Games\StarConflict\user_config.xml")
            };
            Regex legacy = new Regex("(?m)^[ \\t]*<net_masterServerAddress\\s+val=\\\"(" + Regex.Escape(ServerAddress) + ")?\\\"\\s*/>[ \\t]*\\r?\\n");
            int changed = 0;
            foreach (string path in paths)
            {
                if (!File.Exists(path)) continue;
                string text = File.ReadAllText(path, Encoding.UTF8);
                string updated = legacy.Replace(text, "");
                if (updated != text)
                {
                    WriteUtf8(path, updated);
                    changed++;
                }
            }
            return changed;
        }

        internal static void WriteUtf8(string path, string text)
        {
            File.WriteAllText(path, text, new UTF8Encoding(false));
        }

        private static bool IsGameRunning()
        {
            return System.Diagnostics.Process.GetProcessesByName("game").Length > 0 ||
                   System.Diagnostics.Process.GetProcessesByName("StarConflict").Length > 0;
        }

        private void WriteLog(string message)
        {
            log.AppendText("[" + DateTime.Now.ToString("HH:mm:ss") + "] " + message + Environment.NewLine);
        }
    }

    internal static class LauncherMode
    {
        internal static int Run(string[] args)
        {
            LocalServerGuard localServerGuard = null;
            WriteLauncherLog("Launch arguments: " + String.Join(" | ", args));
            try
            {
                string executable = Path.GetFullPath(args[0].Trim('"'));
                if (!File.Exists(executable))
                    throw new FileNotFoundException("Steam game command was not found", executable);

                string gameRoot = FindGameRoot(executable) ?? SetupForm.FindGamePath();
                if (LauncherSettings.GetBoolean("SuppressLocalServer", true))
                    localServerGuard = LocalServerGuard.Disable(gameRoot);
                GameLanguage.ApplyConfigured();
                EnsurePreset(gameRoot);
                ModUpdater.ApplyConfigured(gameRoot);

                ProcessStartInfo start = new ProcessStartInfo();
                start.FileName = executable;
                start.Arguments = JoinGameArguments(args, 1);
                start.WorkingDirectory = Path.GetDirectoryName(executable);
                start.UseShellExecute = false;
                start.EnvironmentVariables["SteamAppId"] = "212070";
                start.EnvironmentVariables["SteamGameId"] = "212070";

                using (Process game = Process.Start(start))
                {
                    if (game == null) return 4;
                    game.WaitForExit();
                    return game.ExitCode;
                }
            }
            catch (Exception ex)
            {
                WriteLauncherLog(ex.ToString());
                // A preset update failure must not prevent the player from
                // starting the game through Steam.
                try
                {
                    ProcessStartInfo fallback = new ProcessStartInfo();
                    fallback.FileName = args[0];
                    fallback.Arguments = JoinGameArguments(args, 1);
                    fallback.WorkingDirectory = Path.GetDirectoryName(Path.GetFullPath(args[0]));
                    fallback.UseShellExecute = false;
                    fallback.EnvironmentVariables["SteamAppId"] = "212070";
                    fallback.EnvironmentVariables["SteamGameId"] = "212070";
                    using (Process game = Process.Start(fallback))
                    {
                        if (game == null) return 5;
                        game.WaitForExit();
                        return game.ExitCode;
                    }
                }
                catch (Exception launchError)
                {
                    WriteLauncherLog(launchError.ToString());
                    return 6;
                }
            }
            finally
            {
                if (localServerGuard != null) localServerGuard.Dispose();
            }
        }

        private static string FindGameRoot(string executable)
        {
            DirectoryInfo directory = new FileInfo(executable).Directory;
            while (directory != null)
            {
                if (SetupForm.IsGameFolder(directory.FullName)) return directory.FullName;
                directory = directory.Parent;
            }
            return null;
        }

        internal static void EnsurePreset(string gameRoot)
        {
            string loginFile = Path.Combine(gameRoot, @"data\ui\scripts\windows\loginwnd.lua");
            if (!File.Exists(loginFile))
                throw new FileNotFoundException("Star Conflict login configuration was not found", loginFile);

            string text = File.ReadAllText(loginFile, Encoding.UTF8);
            string desired = SetupForm.ApplyPreset(text);
            SetupForm.RemoveLegacyServerAddress();
            if (desired == text) return;

            SetupForm.CreateBackup(loginFile);
            SetupForm.WriteUtf8(loginFile, desired);
            WriteLauncherLog("Preset refreshed for " + gameRoot);
        }

        private static string JoinArguments(string[] args, int start)
        {
            StringBuilder result = new StringBuilder();
            for (int i = start; i < args.Length; i++)
            {
                if (result.Length > 0) result.Append(' ');
                result.Append(QuoteArgument(args[i]));
            }
            return result.ToString();
        }

        private static string JoinGameArguments(string[] args, int start)
        {
            if (!LauncherSettings.GetBoolean("SuppressLocalServer", true))
                return JoinArguments(args, start);
            List<string> filtered = new List<string>();
            for (int i = start; i < args.Length; i++)
            {
                if (String.Equals(args[i].Trim(), "-launchLocalServer", StringComparison.OrdinalIgnoreCase))
                    continue;
                filtered.Add(args[i]);
            }
            return JoinArguments(filtered.ToArray(), 0);
        }

        internal static string QuoteArgument(string value)
        {
            if (value.Length > 0 && value.IndexOfAny(new[] { ' ', '\t', '"' }) < 0) return value;
            StringBuilder result = new StringBuilder("\"");
            int slashes = 0;
            foreach (char c in value)
            {
                if (c == '\\') { slashes++; continue; }
                if (c == '"')
                {
                    result.Append('\\', slashes * 2 + 1);
                    result.Append('"');
                    slashes = 0;
                    continue;
                }
                result.Append('\\', slashes);
                slashes = 0;
                result.Append(c);
            }
            result.Append('\\', slashes * 2);
            result.Append('"');
            return result.ToString();
        }

        private static void WriteLauncherLog(string message)
        {
            try
            {
                string state = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                                            @"Targem\StarConflict\community-server-preset");
                Directory.CreateDirectory(state);
                File.AppendAllText(Path.Combine(state, "launcher.log"),
                    "[" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "] " + message + Environment.NewLine,
                    new UTF8Encoding(false));
            }
            catch { }
        }
    }

    internal static class LauncherSettings
    {
        // Built-in values, so the exe works alone; a key in launcher-config.ini overrides them (an empty value disables).
        private static readonly Dictionary<string, string> Defaults = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase) {
            { "NewsFeedUrl", "https://star-conflict-eu-server.mak17.workers.dev/news.json https://sc.profit-cat.com/news.json" },
            { "ModManifestUrl", "https://star-conflict-eu-server.mak17.workers.dev/sc-mods/manifest.txt https://sc.profit-cat.com/sc-mods/manifest.txt" }
        };

        internal static string Get(string key)
        {
            string config = ConfigPath();
            if (File.Exists(config))
            {
                foreach (string raw in File.ReadAllLines(config, Encoding.UTF8))
                {
                    string line = raw.Trim();
                    if (line.StartsWith(key + "=", StringComparison.OrdinalIgnoreCase))
                        return line.Substring(line.IndexOf('=') + 1).Trim();
                }
            }
            string value;
            return Defaults.TryGetValue(key, out value) ? value : String.Empty;
        }

        internal static bool GetBoolean(string key, bool fallback)
        {
            string value = Get(key);
            if (String.IsNullOrWhiteSpace(value)) return fallback;
            bool parsed;
            return Boolean.TryParse(value, out parsed) ? parsed : fallback;
        }

        internal static void Set(string key, string value)
        {
            string config = ConfigPath();
            List<string> lines = File.Exists(config)
                ? File.ReadAllLines(config, Encoding.UTF8).ToList()
                : new List<string>();
            bool found = false;
            for (int i = 0; i < lines.Count; i++)
            {
                string trimmed = lines[i].Trim();
                if (!trimmed.StartsWith(key + "=", StringComparison.OrdinalIgnoreCase)) continue;
                lines[i] = key + "=" + value;
                found = true;
                break;
            }
            if (!found) lines.Add(key + "=" + value);
            File.WriteAllLines(config, lines.ToArray(), new UTF8Encoding(false));
        }

        internal static string ConfigPath()
        {
            return Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "launcher-config.ini");
        }
    }

    // Language flags drawn in code (36x24), so the switch needs no text and no image files.
    internal static class Flags
    {
        private const int W = 36, H = 24;

        internal static Image Russia()
        {
            Bitmap bitmap = new Bitmap(W, H);
            using (Graphics g = Graphics.FromImage(bitmap))
            {
                g.FillRectangle(Brushes.White, 0, 0, W, H / 3);
                using (SolidBrush blue = new SolidBrush(Color.FromArgb(0, 57, 166))) g.FillRectangle(blue, 0, H / 3, W, H / 3);
                using (SolidBrush red = new SolidBrush(Color.FromArgb(213, 43, 30))) g.FillRectangle(red, 0, 2 * H / 3, W, H - 2 * H / 3);
            }
            return bitmap;
        }

        internal static Image UnitedKingdom()
        {
            Bitmap bitmap = new Bitmap(W, H);
            using (Graphics g = Graphics.FromImage(bitmap))
            using (SolidBrush blue = new SolidBrush(Color.FromArgb(1, 33, 105)))
            using (Pen whiteDiagonal = new Pen(Color.White, 5))
            using (Pen redDiagonal = new Pen(Color.FromArgb(200, 16, 46), 2))
            using (SolidBrush red = new SolidBrush(Color.FromArgb(200, 16, 46)))
            {
                g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
                g.FillRectangle(blue, 0, 0, W, H);
                g.DrawLine(whiteDiagonal, 0, 0, W, H);
                g.DrawLine(whiteDiagonal, W, 0, 0, H);
                g.DrawLine(redDiagonal, 0, 0, W, H);
                g.DrawLine(redDiagonal, W, 0, 0, H);
                g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.None;
                g.FillRectangle(Brushes.White, W / 2 - 4, 0, 8, H);
                g.FillRectangle(Brushes.White, 0, H / 2 - 4, W, 8);
                g.FillRectangle(red, W / 2 - 2, 0, 4, H);
                g.FillRectangle(red, 0, H / 2 - 2, W, 4);
            }
            return bitmap;
        }
    }

    internal static class UiText
    {
        internal static bool IsEnglish
        {
            get { return String.Equals(LauncherSettings.Get("Language"), "ENGLISH", StringComparison.OrdinalIgnoreCase); }
        }

        internal static string T(string russian, string english)
        {
            return IsEnglish ? english : russian;
        }
    }

    internal static class GameLanguage
    {
        internal static string GetConfigured()
        {
            string value = LauncherSettings.Get("Language").Trim().ToUpperInvariant();
            if (value == "ENGLISH" || value == "RUSSIAN") return value;
            foreach (string path in ConfigPaths())
            {
                if (!File.Exists(path)) continue;
                Match match = Regex.Match(File.ReadAllText(path, Encoding.UTF8), "<cl_language\\s+val=\\\"(RUSSIAN|ENGLISH)\\\"\\s*/>", RegexOptions.IgnoreCase);
                if (match.Success) return match.Groups[1].Value.ToUpperInvariant();
            }
            return "RUSSIAN";
        }

        internal static void ApplyConfigured()
        {
            Apply(GetConfigured());
        }

        internal static void Apply(string value)
        {
            string normalized = String.Equals(value, "ENGLISH", StringComparison.OrdinalIgnoreCase) ? "ENGLISH" : "RUSSIAN";
            foreach (string path in ConfigPaths())
            {
                if (!File.Exists(path)) continue;
                string text = File.ReadAllText(path, Encoding.UTF8);
                string updated = Regex.Replace(text, "<cl_language\\s+val=\\\"[^\\\"]*\\\"\\s*/>", "<cl_language val=\"" + normalized + "\" />", RegexOptions.IgnoreCase);
                if (updated != text) File.WriteAllText(path, updated, new UTF8Encoding(false));
            }
        }

        private static string[] ConfigPaths()
        {
            return new[] {
                Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), @"Targem\StarConflict\user_config.xml"),
                Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), @"My Games\StarConflict\user_config.xml")
            };
        }
    }

    internal sealed class LocalServerGuard : IDisposable
    {
        private const string Marker = "@rem SC-Launcher: local server suppressed";
        private readonly string script;
        private readonly string backup;
        private bool active;

        private LocalServerGuard(string scriptPath)
        {
            script = scriptPath;
            backup = scriptPath + ".sc-launcher-backup";
        }

        internal static LocalServerGuard Disable(string gameRoot)
        {
            LocalServerGuard guard = new LocalServerGuard(Path.Combine(gameRoot, @"win64\launch_server_and_db.bat"));
            guard.Apply();
            return guard;
        }

        private void Apply()
        {
            if (File.Exists(backup) && IsStub(script))
            {
                File.Delete(script);
                File.Move(backup, script);
            }
            if (!File.Exists(script)) return;
            if (File.Exists(backup))
                throw new IOException("Local-server backup already exists: " + backup);

            File.Move(script, backup);
            try
            {
                File.WriteAllText(script, "@echo off\r\n" + Marker + "\r\nexit /b 0\r\n", Encoding.ASCII);
                active = true;
            }
            catch
            {
                if (!File.Exists(script) && File.Exists(backup)) File.Move(backup, script);
                throw;
            }
        }

        public void Dispose()
        {
            if (!active) return;
            try
            {
                if (IsStub(script) && File.Exists(backup))
                {
                    File.Delete(script);
                    File.Move(backup, script);
                }
            }
            catch { }
            active = false;
        }

        private static bool IsStub(string path)
        {
            if (!File.Exists(path)) return false;
            try { return File.ReadAllText(path, Encoding.ASCII).IndexOf(Marker, StringComparison.Ordinal) >= 0; }
            catch { return false; }
        }
    }

    [DataContract]
    internal sealed class NewsFeed
    {
        [DataMember(Name = "version")]
        public int Version { get; set; }

        [DataMember(Name = "items")]
        public List<NewsItem> Items { get; set; }
    }

    [DataContract]
    internal sealed class NewsItem
    {
        [DataMember(Name = "id")]
        public string Id { get; set; }

        [DataMember(Name = "title")]
        public string Title { get; set; }

        [DataMember(Name = "date")]
        public string Date { get; set; }

        [DataMember(Name = "summary")]
        public string Summary { get; set; }

        [DataMember(Name = "url")]
        public string Url { get; set; }

        // news.json v2: per-language texts and an ISO date ("2026-10-21"); title/summary/date above stay for v1 feeds.
        [DataMember(Name = "ru")]
        public NewsText Ru { get; set; }

        [DataMember(Name = "en")]
        public NewsText En { get; set; }
    }

    [DataContract]
    internal sealed class NewsText
    {
        [DataMember(Name = "title")]
        public string Title { get; set; }

        [DataMember(Name = "summary")]
        public string Summary { get; set; }

        // Optional per-language link (e.g. the /ru/ page); the item's url is the fallback.
        [DataMember(Name = "url")]
        public string Url { get; set; }
    }

    internal static class NewsService
    {
        private const int MaxFeedBytes = 262144;

        internal static List<NewsItem> Load()
        {
            // Like ModManifestUrl: several feeds separated by spaces or '|', tried in order.
            string[] urls = LauncherSettings.Get("NewsFeedUrl").Split(new[] { ' ', '|', '\t' }, StringSplitOptions.RemoveEmptyEntries);
            if (urls.Length == 0) return Fallback();
            foreach (string url in urls)
            {
                Uri uri;
                if (!Uri.TryCreate(url, UriKind.Absolute, out uri) || uri.Scheme != Uri.UriSchemeHttps) continue;
                try
                {
                    byte[] json = Download(uri);
                    List<NewsItem> items = Parse(json);
                    string cache = CachePath();
                    Directory.CreateDirectory(Path.GetDirectoryName(cache));
                    File.WriteAllBytes(cache, json);
                    return items;
                }
                catch { }
            }
            return LoadCacheOrFallback();
        }

        internal static List<NewsItem> Fallback()
        {
            return new List<NewsItem> {
                new NewsItem {
                    Id = "detonation-bots-update",
                    Title = UiText.T("Обновление ботов и режима «Детонация»", "Bots and Detonation mode update"),
                    Date = UiText.T("14 ОКТЯБРЯ 2026", "14 OCTOBER 2026"),
                    Summary = UiText.T("Боты снова подбирают и доставляют бомбу, устанавливают заряд, защищают союзного носителя и атакуют вражеского. Бои против ИИ рассчитаны на восемь игроков и снова выдают стандартные награды. Также боты точнее стреляют, используют модули и ракеты, уклоняются от огня и летают на кораблях соответствующего уровня.", "Bots once again pick up and deliver bombs, plant charges, protect allied carriers and attack enemy carriers. Battles against AI support eight players and award standard rewards again. Bots also aim more accurately, use modules and missiles, evade fire and fly ships appropriate for their tier."),
                    Url = "https://star-conflict-eu-server.mak17.workers.dev"
                }
            };
        }

        private static List<NewsItem> LoadCacheOrFallback()
        {
            try
            {
                string cache = CachePath();
                if (File.Exists(cache) && new FileInfo(cache).Length <= MaxFeedBytes)
                    return Parse(File.ReadAllBytes(cache));
            }
            catch { }
            return Fallback();
        }

        private static List<NewsItem> Parse(byte[] json)
        {
            using (MemoryStream stream = new MemoryStream(json))
            {
                DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(NewsFeed));
                NewsFeed feed = serializer.ReadObject(stream) as NewsFeed;
                if (feed == null || feed.Items == null || feed.Items.Count == 0)
                    throw new InvalidDataException("News feed is empty");
                return feed.Items.Select(Localize).Where(ValidItem).Take(10).ToList();
            }
        }

        private static readonly string[] MonthsRu = { "ЯНВАРЯ", "ФЕВРАЛЯ", "МАРТА", "АПРЕЛЯ", "МАЯ", "ИЮНЯ", "ИЮЛЯ", "АВГУСТА", "СЕНТЯБРЯ", "ОКТЯБРЯ", "НОЯБРЯ", "ДЕКАБРЯ" };
        private static readonly string[] MonthsEn = { "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER" };

        private static NewsItem Localize(NewsItem item)
        {
            if (item == null) return null;
            NewsText text = UiText.IsEnglish ? (item.En ?? item.Ru) : (item.Ru ?? item.En);
            if (text != null)
            {
                item.Title = text.Title;
                item.Summary = text.Summary;
                if (!String.IsNullOrWhiteSpace(text.Url)) item.Url = text.Url;
            }
            DateTime date;
            if (DateTime.TryParseExact(item.Date ?? String.Empty, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out date))
                item.Date = date.Day + " " + (UiText.IsEnglish ? MonthsEn : MonthsRu)[date.Month - 1] + " " + date.Year;
            return item;
        }

        private static bool ValidItem(NewsItem item)
        {
            if (item == null || String.IsNullOrWhiteSpace(item.Title) || String.IsNullOrWhiteSpace(item.Summary)) return false;
            if (item.Title.Length > 120 || item.Summary.Length > 1000 || (item.Date ?? String.Empty).Length > 40) return false;
            if (String.IsNullOrWhiteSpace(item.Url)) return true;
            Uri uri;
            return Uri.TryCreate(item.Url, UriKind.Absolute, out uri) && uri.Scheme == Uri.UriSchemeHttps;
        }

        private static byte[] Download(Uri uri)
        {
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(uri);
            request.Timeout = 5000;
            request.ReadWriteTimeout = 5000;
            request.UserAgent = "SC-Launcher/0.7.1";
            using (WebResponse response = request.GetResponse())
            using (Stream input = response.GetResponseStream())
            using (MemoryStream output = new MemoryStream())
            {
                byte[] buffer = new byte[8192];
                int read;
                while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
                {
                    if (output.Length + read > MaxFeedBytes) throw new InvalidDataException("News feed is too large");
                    output.Write(buffer, 0, read);
                }
                return output.ToArray();
            }
        }

        private static string CachePath()
        {
            return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                @"Targem\StarConflict\community-server-preset\news-cache.json");
        }
    }

    internal static class ModUpdater
    {
        // ModManifestUrl may list several manifests separated by spaces or '|': the main site first, then
        // mirrors. A network failure (e.g. an ISP resetting *.workers.dev) moves on to the next source;
        // files already installed from the previous one pass the hash check and are not downloaded again.
        internal static string ApplyConfigured(string gameRoot)
        {
            string[] sources = LauncherSettings.Get("ModManifestUrl").Split(new[] { ' ', '|', '\t' }, StringSplitOptions.RemoveEmptyEntries);
            if (sources.Length == 0) return String.Empty;
            Exception last = null;
            foreach (string source in sources)
            {
                try { return ApplyFrom(gameRoot, source); }
                catch (WebException ex) { last = ex; }
                catch (IOException ex) { last = ex; }
            }
            throw last;
        }

        private static string ApplyFrom(string gameRoot, string manifestUrl)
        {
            Uri manifestUri;
            if (!Uri.TryCreate(manifestUrl, UriKind.Absolute, out manifestUri) || manifestUri.Scheme != Uri.UriSchemeHttps)
                throw new InvalidDataException("ModManifestUrl must use HTTPS");

            string manifest;
            using (WebClient client = NewClient()) manifest = client.DownloadString(manifestUri);
            string[] lines = manifest.Replace("\r\n", "\n").Split('\n');
            if (lines.Length == 0 || lines[0].Trim() != "SCMOD1")
                throw new InvalidDataException("Unsupported mod manifest format");

            int updated = 0;
            for (int index = 1; index < lines.Length; index++)
            {
                string line = lines[index].Trim();
                if (line.Length == 0 || line.StartsWith("#")) continue;
                string[] fields = line.Split('\t');
                if (fields.Length != 3) throw new InvalidDataException("Invalid mod manifest line " + (index + 1));
                string relative = fields[0].Replace('/', '\\');
                ValidateRelativePath(relative);
                string expectedHash = fields[1].Trim().ToUpperInvariant();
                if (!Regex.IsMatch(expectedHash, "^[0-9A-F]{64}$"))
                    throw new InvalidDataException("Invalid SHA-256 for " + relative);
                Uri fileUri;
                if (!Uri.TryCreate(fields[2].Trim(), UriKind.Absolute, out fileUri) || fileUri.Scheme != Uri.UriSchemeHttps)
                    throw new InvalidDataException("Update URL must use HTTPS for " + relative);

                string target = Path.GetFullPath(Path.Combine(gameRoot, relative));
                string rootPrefix = Path.GetFullPath(gameRoot).TrimEnd('\\') + "\\";
                if (!target.StartsWith(rootPrefix, StringComparison.OrdinalIgnoreCase))
                    throw new InvalidDataException("Update path escapes the game directory: " + relative);
                if (File.Exists(target) && Sha256(target) == expectedHash) continue;

                string temp = target + ".scupdate.tmp";
                Directory.CreateDirectory(Path.GetDirectoryName(target));
                using (WebClient client = NewClient()) client.DownloadFile(fileUri, temp);
                if (Sha256(temp) != expectedHash)
                {
                    File.Delete(temp);
                    throw new InvalidDataException("Downloaded SHA-256 mismatch for " + relative);
                }
                if (File.Exists(target))
                {
                    // The first replaced version is the game's own file: keep it for "Remove modification".
                    string original = Path.Combine(OriginalsRoot(), relative);
                    if (!File.Exists(original) && !IsListedAsAdded(relative))
                    {
                        Directory.CreateDirectory(Path.GetDirectoryName(original));
                        File.Copy(target, original, false);
                    }
                    string backupRoot = Path.Combine(StateRoot(), "mod-backups", DateTime.Now.ToString("yyyyMMdd-HHmmss"));
                    string backup = Path.Combine(backupRoot, relative);
                    Directory.CreateDirectory(Path.GetDirectoryName(backup));
                    File.Copy(target, backup, true);
                    File.Replace(temp, target, null);
                }
                else
                {
                    if (!File.Exists(Path.Combine(OriginalsRoot(), relative)) && !IsListedAsAdded(relative))
                        File.AppendAllText(AddedListPath(), relative + Environment.NewLine, new UTF8Encoding(false));
                    File.Move(temp, target);
                }
                updated++;
            }
            return updated == 0 ? UiText.T("МОДЫ АКТУАЛЬНЫ", "MODS ARE UP TO DATE") : UiText.T("УСТАНОВЛЕНО ФАЙЛОВ: ", "FILES INSTALLED: ") + updated;
        }

        // Puts back every game file the updater replaced and deletes the files it added. Returns the number of files touched.
        internal static int RestoreOriginals(string gameRoot)
        {
            int restored = 0;
            string rootPrefix = Path.GetFullPath(gameRoot).TrimEnd('\\') + "\\";
            string originals = OriginalsRoot();
            if (Directory.Exists(originals))
            {
                string originalsPrefix = Path.GetFullPath(originals).TrimEnd('\\') + "\\";
                foreach (string original in Directory.GetFiles(originals, "*", SearchOption.AllDirectories))
                {
                    string relative = Path.GetFullPath(original).Substring(originalsPrefix.Length);
                    string target = Path.GetFullPath(Path.Combine(gameRoot, relative));
                    if (!target.StartsWith(rootPrefix, StringComparison.OrdinalIgnoreCase)) continue;
                    Directory.CreateDirectory(Path.GetDirectoryName(target));
                    File.Copy(original, target, true);
                    restored++;
                }
                Directory.Delete(originals, true);
            }
            string added = AddedListPath();
            if (File.Exists(added))
            {
                foreach (string line in File.ReadAllLines(added, Encoding.UTF8))
                {
                    string relative = line.Trim();
                    if (relative.Length == 0) continue;
                    ValidateRelativePath(relative);
                    string target = Path.GetFullPath(Path.Combine(gameRoot, relative));
                    if (!target.StartsWith(rootPrefix, StringComparison.OrdinalIgnoreCase)) continue;
                    if (File.Exists(target)) { File.Delete(target); restored++; }
                }
                File.Delete(added);
            }
            return restored;
        }

        private static bool IsListedAsAdded(string relative)
        {
            string added = AddedListPath();
            if (!File.Exists(added)) return false;
            foreach (string line in File.ReadAllLines(added, Encoding.UTF8))
                if (String.Equals(line.Trim(), relative, StringComparison.OrdinalIgnoreCase)) return true;
            return false;
        }

        private static string StateRoot()
        {
            string state = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                @"Targem\StarConflict\community-server-preset");
            Directory.CreateDirectory(state);
            return state;
        }

        private static string OriginalsRoot() { return Path.Combine(StateRoot(), "mod-originals"); }

        private static string AddedListPath() { return Path.Combine(StateRoot(), "mod-added.txt"); }

        private static WebClient NewClient()
        {
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            WebClient client = new WebClient();
            client.Headers[HttpRequestHeader.UserAgent] = "SC-Launcher/0.7.1";
            return client;
        }

        private static void ValidateRelativePath(string path)
        {
            if (String.IsNullOrWhiteSpace(path) || Path.IsPathRooted(path) ||
                path.Split('\\').Contains("..") || path.IndexOf(':') >= 0)
                throw new InvalidDataException("Unsafe update path: " + path);
        }

        private static string Sha256(string path)
        {
            using (SHA256 sha = SHA256.Create())
            using (FileStream stream = File.OpenRead(path))
                return BitConverter.ToString(sha.ComputeHash(stream)).Replace("-", "");
        }
    }
}
