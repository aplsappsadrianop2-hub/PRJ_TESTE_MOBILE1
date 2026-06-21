unit FrmAp2AppMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Memo.Types, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, FMX.ScrollBox, FMX.Memo,
  FMX.Layouts, FMX.TabControl, FMX.WebBrowser, FMX.Printer,

  // 1. Units essenciais para o evento ShouldStartLoadWithRequest reconhecer o TWebBrowserLoadJob
  //FMX.WebBrowser.Delegate,

  // 2. Units nativas para a ponte Delphi -> Android (Intent e Strings do Java)
  {$IFDEF ANDROID}
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  Androidapi.JNI.Net,       // Importante para trabalhar com URIs de Intent
  Androidapi.JNIBridge,    // Ponte de comunicação Java
  {$ENDIF}

  FMX.KeyMapping, FMX.Ani;


type
  TFrmAppMain = class(TForm)
    NetHTTPClient1: TNetHTTPClient;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    MemoResultado: TMemo;
    WebBrowser1: TWebBrowser;
    edtNavegador: TEdit;
    Panel1: TPanel;
    edtHttp: TEdit;
    edtUrl: TEdit;
    Button1: TButton;
    TabItemImagem: TTabItem;
    SpeedButton1: TSpeedButton;
    FloatKeyAnimation1: TFloatKeyAnimation;
    FloatAnimation1: TFloatAnimation;
    procedure Button1Click(Sender: TObject);
    procedure edtNavegadorKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure TabControl1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar;
      Shift: TShiftState);
    procedure WebBrowser1DidFailLoadWithError(ASender: TObject);
    procedure TabItemImagemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    //procedure WebBrowser1ShouldStartLoadWithRequest(Sender: TObject; const URL: string; const Job: TWebBrowserLoadJob);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAppMain: TFrmAppMain;
  FormImagem: TFrame;

implementation

uses FrmAp2Image; // Nome do arquivo .pas


{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TFrmAppMain.Button1Click(Sender: TObject);
var
  Resposta: string;
begin
  // Proteção: Evita tentar navegar se os campos estiverem vazios
  if (edtHttp.Text = '') and (edtUrl.Text = '') then
  begin
    MemoResultado.Lines.Text := 'Por favor, digite uma URL válida.';
    Exit;
  end;

  MemoResultado.Lines.Clear;
  MemoResultado.Lines.Add('Buscando informações, aguarde...');

  try
    // Junta o prefixo (ex: http://) com o restante da URL
    Resposta := NetHTTPClient1.Get(EdtHttp.Text + EdtUrl.Text).ContentAsString;

    MemoResultado.Lines.Clear;
    MemoResultado.Lines.Add(Resposta);
  except
    on E: Exception do
    begin
      MemoResultado.Lines.Clear;
      MemoResultado.Lines.Add('Erro ao conectar: ' + E.Message);
    end;
  end;
end;

procedure TFrmAppMain.edtNavegadorKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  // Tecla 13 = Enter
  if Key = 13 then
  begin
    if edtNavegador.Text <> '' then
      WebBrowser1.Navigate(edtNavegador.Text);
  end;
  // REMOVIDO: Application.ProcessMessages (Causa do Erro 10 no Android)
end;

procedure TFrmAppMain.FormCreate(Sender: TObject);
begin
 // 1. Verifica se o formulário (TFrmImage) já não está criado
  if FormImagem = nil then
  begin
    // 2. Cria o formulário na memória
   // FormImagem := TFrmImage.Create(Self);
   FormImagem := TFrmImage.Create(Self);
  end;
end;

procedure TFrmAppMain.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  // Verifica se o botão pressionado foi o "Voltar" físico do Android
  if Key = vkHardwareBack then
  begin
    // 1. Se estivermos na aba do navegador (TabItem2)
    if TabControl1.ActiveTab = TabItem2 then
    begin
      // 2. Se o navegador tiver páginas para voltar no histórico
      if WebBrowser1.CanGoBack then
      begin
        WebBrowser1.GoBack; // Volta a página interna
        Key := 0; // Previne o Android de fechar o aplicativo
        Exit;
      end
      else
      begin
        // Se não tem mais para onde voltar na web, joga o usuário para a Aba 1
        TabControl1.ActiveTab := TabItem1;
        Key := 0; // Previne o Android de fechar o aplicativo
        Exit;
      end;
    end;
  end;
end;

procedure TFrmAppMain.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmAppMain.TabControl1Change(Sender: TObject);
var
  UrlCompleta: string;
begin
  // Verifica se o usuário mudou para a Aba do Navegador
  if TabControl1.ActiveTab = TabItem2 then
  begin
    // Monta a URL usando os edits existentes na tela
    UrlCompleta := edtNavegador.Text;

    if UrlCompleta <> '' then
    begin
      try
        // Força o navegador a abrir a URL da pesquisa
        WebBrowser1.Navigate(UrlCompleta);
      except
        // Protege o componente nativo
      end;
    end;
  end;
end;

procedure TFrmAppMain.TabItemImagemClick(Sender: TObject);
//var   FormImagem: TFrmImage;
begin
 // 0. Verifica se o formulário (TFrmImage) já não está criado
  if FormImagem = nil then
  begin
    // 2. Cria o formulário na memória
   // FormImagem := TFrmImage.Create(Self);
   FormImagem := TFrmImage.Create(Self);
  end;
  // 1. Cria o segundo formulário na memória anexado ao principal
  //FormImagem := TFrmImage.Create(Self);

  // 2. Injeta o formulário diretamente como filho visual da aba ativa
  FormImagem.Parent := TabControl1.ActiveTab;

  // 3. Força ele a cobrir 100% do espaço da aba (isso elimina bordas automaticamente)
  FormImagem.Align := TAlignLayout.Client;

  // 4. Exibe o ninja e o seu ImageViewer na tela
  //FormImagem.Show;
end;

procedure TFrmAppMain.WebBrowser1DidFailLoadWithError(ASender: TObject);
begin

end;

//
//procedure TForm1.WebBrowser1ShouldStartLoadWithRequest(Sender: TObject; const URL: string; const Job: TWebBrowserLoadJob);
//{$IFDEF ANDROID}
//var
//  Intent: JIntent;
//{$ENDIF}
//begin
//  // Se o link começar com intent://, maps://, whatsapp://, tel://, etc.
//  if not URL.StartsWith('http://', True) and not URL.StartsWith('https://', True) then
//  begin
//    // Cancela o carregamento dentro do nosso navegador para não dar a tela de erro
//    Job.Cancel;
//
//    {$IFDEF ANDROID}
//    try
//      // Cria uma intenção no Android para abrir o link no aplicativo correto do celular
//      Intent := TJIntent.JavaClass.parseUri(StringToJString(URL), TJIntent.JavaClass.URI_INTENT_SCHEME);
//
//      if Intent <> nil then
//      begin
//        Intent.addCategory(TJIntent.JavaClass.CATEGORY_BROWSABLE);
//        Intent.setComponent(nil);
//
//        // Dispara o aplicativo externo (ex: Google Maps) no seu Infinix
//        TAndroidHelper.Activity.startActivity(Intent);
//      end;
//    except
//      // Se o celular não tiver o aplicativo instalado, evita que o app trave
//    end;
//    {$ENDIF}
//  end;
//end;
//
end.
