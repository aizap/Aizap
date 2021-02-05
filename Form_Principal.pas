unit Form_Principal;

interface

uses
  uAudioVisualControl,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Objects, FMX.TextLayout, Data.DB, FMX.TabControl, System.Actions,
  FMX.ActnList, System.JSON, Soap.EncdDecd, FMX.Layouts, FMX.ImgList,

  FMX.Media,
   FMX.Effects, System.IOUtils,
    FMX.Ani,  System.netEncoding, System.Messaging;

type
  TFrm_Principal = class(TForm)
    ToolBar1: TToolBar;
    ListView: TListView;
    TabControl: TTabControl;
    TabContatos: TTabItem;
    img_fundo_qtd: TImage;
    Label1: TLabel;
    ActionList1: TActionList;
    ActContatos: TChangeTabAction;
    ActChat: TChangeTabAction;
    StyleBook1: TStyleBook;
    ToolBar2: TToolBar;
    lbl_nome: TLabel;
    btn_voltar: TSpeedButton;
    LayoutLista: TLayout;
    LayoutChat: TLayout;
    Image1: TImage;
    lv_chat: TListView;
    ///--------------------


    procedure FormCreate(Sender: TObject);
    procedure Carrega_Contatos();
    procedure Carrega_Chat(cod_usuario : integer; nome : string);
    procedure FormShow(Sender: TObject);
    procedure ListViewUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ListViewItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_chatUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btn_voltarClick(Sender: TObject);
    procedure Setup_ItemTexto(item: TListViewItem);
    procedure Setup_ItemFoto(item: TListViewItem);
    procedure Setup_ItemAudio(item: TListViewItem);
  private
    { Private declarations }
  public
    { Public declarations }


    //--------------------
  end;

var
  Frm_Principal: TFrm_Principal;

implementation



{$R *.fmx}

uses Data_Module;
Const
  fotoFechar : String = 'iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAYAAABV7bNHAAABHElEQVR4AWIYBYB27AADoSAKo3B4' +
                        'gJbULlpICwmzhBbwFhFaUoAwDYGuyhtw+jmHH4DxgXE/ZmZmZmZmZmbWez+OneE3LGOXscM/4jz6' +
                        'qwbirP3VnUeqOO81EKfjSF9wag3EqUgY0LX/rgE4tQsJtB+7EUgbcdaxBaChkHgcHonH4ZF4nHwk' +
                        'HodH4nHykXgcHgnAyUMCcPKQAJw8JAAnDwnAyUICcGKQxKlI4kwgiTPxzyk1cUTahCNSxRFpHmel' +
                        'btwpOAtx447BIW7ccTh5SABOHhKAk4cE4OQhATg8Eo+Tj8Tj8Eg8Tj4SjxOHNI+DIJ1JoNMMDoD0' +
                        'GDvuajxSxUGQKg6PROBUpCkcAKniEEjXrzhmZmZmZmZmZvYEbCYPnlG3fB4AAAAASUVORK5CYII=';

  fotoPlay : String = 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAAi0lEQVR4Ae2WsRVAYBDGqJRqAxjDDrYwhE0sYQdjGECtVInmWyGVywJ5j/x31/yBoijYGVwB3Cy0pgDgYHQF8LDSaYJwMrkCeNnoNUG4'+
                      'mEVB2BlcQeI1BYnXFSReU5B4XUHiNQWJ1xf4n8j/yX6m/kPzR4U/7Pxx7S8ca2UKS98/W/zDyz8di6L4AR9PTYeLvT6BSgAAAABJRU5ErkJggg==';
  fotoStop : String = 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQAAAAB/ecQqAAAAAnRSTlMAAHaTzTgAAAATSURBVHgBY6AJ4P///8Pgp2gBAPUeR7nHgTImAAAAAElFTkSuQmCC';
  fotoMicrophone : String = 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABh0lEQVR4Ae3UMwMWXBiA4efzl23tuZ+Tbbstrbkp2zXnJbsl27Z9pbPkXsX3mo7v7UTRz8N/ejkOjuvlv8gvNR2UgINqRv74wxbv2+qP'+
                            'yBcdAEeNMNdjQMfIF9vAFWXfzBp7DHZEvrgPFkViObgX+QKYEompQOEC0wofgBeFC0wHzwsXmAGe/cSBmeBpoQNPCheYVejAbPC40IFHhQvMyTHgHhj43nx5JFaAG5EYlOHn5xgYG4lt4LFmb2YVXAMb'+
                            'IzEOHIuvZS1YFYkOgEcWGuE4oM1759fF19IPPFYmzf+01fs2+TPeUNMLMCy+lnpegL6RqGU/kOxXMxKTAU3j61kB7qgQif/0dByc0st/kWjgGdgWmdAAsN7f8RmqOQ1oFpkxAbBcmfgEdR0ATIhM+dde'+
                            'wAUt4iO0cQuw17+ROZXtItmpvdqRqK29nRJ7VIrs+N9cCbhpr71uSsA8/0cutHXfp9zTNnKngg5WeSJJrhmtSuSPslpIdNHUX5F/kkiKgWIgT4qKXgLKHON17xQ48QAAAABJRU5ErkJggg==';
  fotoDelete : String = 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAA0ElEQVR4Ae3UgQbCUBiG4UOaAQTRxYwA6KZ2KQVgDAMzdjkbMIAZ8CbGZ6BOPkWdF/Dje4A/pFKfiRKlSv+8i+DNEmAAfioi+zaQgAQs'+
                        'XGhR0HFhcQEz5xDIRNCxD4Ezswco1ktGr/lHFB6gYrfecnrNs6P2ABtiO+8ARCjNuwARmncD9QaozIDmRRgBzZOTi3ABmt/T0ZKJ8ACF5gEQUdheheZFeF6Fnl0HqNbw7OL6R2AgpiEeuBLTLR44MvJq'+
                        'I4cQHycaJp410XAKqZQ9dQddZ5kTV71WWQAAAABJRU5ErkJggg==';

function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

function Base64FromBitmap(Bitmap: TBitmap): string;
var
  Input: TBytesStream;
  Output: TStringStream;
begin
        Input := TBytesStream.Create;
        try
                Bitmap.SaveToStream(Input);
                Input.Position := 0;
                Output := TStringStream.Create('', TEncoding.ASCII);

                try
                        Soap.EncdDecd.EncodeStream(Input, Output);
                        Result := Output.DataString;
                finally
                        Output.Free;
                end;

        finally
                Input.Free;
        end;
end;

function BitmapFromBase64(const base64: string): TBitmap;
var
        Input: TStringStream;
        Output: TBytesStream;
begin
        Input := TStringStream.Create(base64, TEncoding.ASCII);
        try
                Output := TBytesStream.Create;
                try
                        Soap.EncdDecd.DecodeStream(Input, Output);
                        Output.Position := 0;
                        Result := TBitmap.Create;
                        try
                                Result.LoadFromStream(Output);
                        except
                                Result.Free;
                                raise;
                        end;
                finally
                        Output.DisposeOf;
                end;
        finally
                Input.DisposeOf;
        end;
end;

function GetLabelHeight(const D: TLabel; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.VertTextAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

procedure TFrm_Principal.Carrega_Contatos;
var
    item : TListViewItem;
    txt : TListItemText;
    img : TListItemImage;
    foto : TStream;
begin
    dm.qry_msg.Active := false;
    dm.qry_msg.SQL.Clear;
    dm.qry_msg.sql.Add('SELECT * FROM TAB_CONTATOS ORDER BY DT_ULT_MSG DESC');
    dm.qry_msg.Active := true;

    while NOT dm.qry_msg.Eof do
    begin
        item := ListView.Items.Add;
        item.Height := 70;
        item.Tag := dm.qry_msg.FieldByName('COD_USUARIO').AsInteger;
        item.TagString := dm.qry_msg.FieldByName('NOME').AsString;

        with item do
        begin
            // Foto...
            if dm.qry_msg.FieldByName('ICONE').AsString <> '' then
            begin
                img := Objects.FindDrawable('ImgFoto') as TListItemImage;
                img.OwnsBitmap := true;

                foto := dm.qry_msg.CreateBlobStream(dm.qry_msg.FieldByName('ICONE'), TBlobStreamMode.bmRead);
                img.Bitmap := TBitmap.CreateFromStream(foto);

                foto.DisposeOf;
            end;

            // Nome...
            txt := Objects.FindDrawable('TxtNome') as TListItemText;
            txt.Text := dm.qry_msg.FieldByName('NOME').AsString;

            // Mensagem...
            txt := Objects.FindDrawable('TxtMsg') as TListItemText;
            txt.Text := dm.qry_msg.FieldByName('ULT_MSG').AsString;

            // Data...
            txt := Objects.FindDrawable('TxtData') as TListItemText;
            txt.Text := FormatDateTime('dd/mm/yy', dm.qry_msg.FieldByName('DT_ULT_MSG').AsDateTime);

            // Qtd...
            if dm.qry_msg.FieldByName('QTD_MSG').AsInteger > 0 then
            begin
                txt := Objects.FindDrawable('TxtQtd') as TListItemText;
                txt.TagFloat := dm.qry_msg.FieldByName('QTD_MSG').AsFloat;
            end;
        end;

        dm.qry_msg.Next;
    end;
end;

procedure TFrm_Principal.btn_voltarClick(Sender: TObject);
begin
    ActContatos.Execute;
end;

procedure TFrm_Principal.Carrega_Chat(cod_usuario : integer; nome : string);
var
    item : TListViewItem;
    txt : TListItemText;
    img : TListItemImage;
    foto : TStream;
    foto_base64 : string;
    bmp : TBitmap;
begin
    lv_chat.Items.Clear;
    lbl_nome.Text := nome;

    dm.qry_chat.Active := false;
    dm.qry_chat.SQL.Clear;
    dm.qry_chat.sql.Add('SELECT * FROM TAB_CONTATOS_CHAT');
    dm.qry_chat.sql.Add('WHERE COD_USUARIO = :COD_USUARIO');
    dm.qry_chat.sql.Add('ORDER BY DT_MSG');
    dm.qry_chat.ParamByName('COD_USUARIO').Value := cod_usuario;
    dm.qry_chat.Active := true;

    while NOT dm.qry_chat.Eof do
    begin
        // Foto base 64...
        foto_base64 := '';
        if dm.qry_chat.FieldByName('TIPO_MSG').AsString = 'I' then
        begin
            foto := dm.qry_chat.CreateBlobStream(dm.qry_chat.FieldByName('IMAGEM'), TBlobStreamMode.bmRead);

            if foto <> nil then
            begin
                    bmp := TBitmap.Create;
                    bmp.LoadFromStream(foto);

                    foto_base64 := Base64FromBitmap(bmp);

                    bmp.DisposeOf;
            end;

            foto.DisposeOf;
        end;



        item := lv_chat.Items.Add;
        item.Height := 150;
        item.Tag := dm.qry_chat.FieldByName('COD_USUARIO').AsInteger;
        item.TagString := Format('{"cod_mensagem": "%s", "texto": "%s", "data":"%s", "ind_propria":"%s", "foto":"%s"}',
                                 [dm.qry_chat.FieldByName('COD_MENSAGEM').AsString,
                                 dm.qry_chat.FieldByName('TEXTO').AsString,
                                 FormatDateTime('HH:MM', dm.qry_chat.FieldByName('DT_MSG').AsDateTime),
                                 dm.qry_chat.FieldByName('IND_MSG_PROPRIA').AsString,
                                 foto_base64]);

        dm.qry_chat.Next;
    end;
end;

procedure TFrm_Principal.FormCreate(Sender: TObject);
begin
  //  Audio := TAudioVisualControl.create(self);
    TabControl.ActiveTab := TabContatos;
    TabControl.TabPosition := TTabPosition.None;
    img_fundo_qtd.Visible := false;

end;

procedure TFrm_Principal.FormShow(Sender: TObject);
begin
    Carrega_Contatos;
end;

procedure TFrm_Principal.ListViewItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    // Monta a lista das mensagens...
    Carrega_Chat(Aitem.Tag, Aitem.TagString);

   // ActChat.Execute;
end;

procedure TFrm_Principal.ListViewUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    txt : TListItemText;
    img : TListItemImage;
begin
    with AItem do
    begin
        // Nome...
        txt := Objects.FindDrawable('TxtNome') as TListItemText;
        txt.Width := ListView.Width - 61 - 90;

        // Mensagem...
        txt := Objects.FindDrawable('TxtMsg') as TListItemText;
        txt.Width := ListView.Width - 61 - 65;

        // Qtd e fundo...
        txt := Objects.FindDrawable('TxtQtd') as TListItemText;
        if txt.TagFloat > 0 then
        begin
            txt.Text := dm.qry_msg.FieldByName('QTD_MSG').AsString;
            txt.Visible := true;
            txt.TagFloat := dm.qry_msg.FieldByName('QTD_MSG').AsFloat;
            txt.Width := 22;
            txt.Height := 22;
            txt.TextColor := $FFFFFFFF;

            img := Objects.FindDrawable('ImgQtd') as TListItemImage;
            img.OwnsBitmap := false;
            img.Visible := true;
            img.Width := 22;
            img.Height := 22;
            img.Bitmap := img_fundo_qtd.bitmap;
            img.PlaceOffset.X := txt.PlaceOffset.X;
            img.PlaceOffset.Y := txt.PlaceOffset.Y;
        end;
    end;
end;

procedure TFrm_Principal.Setup_ItemTexto(item: TListViewItem);
var

    lbl, lbl2,lyPlay : TLabel;
    JsonObj : TJSONObject;
    rect : TRectangle;
    emb : TListItemEmbeddedControl;
    altura : single;
    lyGravacao : TLayout;
    btnGravacao : TRectangle;
    imgGravacao : TRectangle;
    lbGravacao :TLabel;
begin
    Item.Height := 100;
    altura := 0;

    try
        JsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(item.TagString), 0) as TJSONObject;

        // Texto...
        lbl := TLabel.Create(ListView);
        lbl.Text := TJSONObject(JsonObj).GetValue('texto').Value;
        lbl.Align := TAlignLayout.Left;
        lbl.VertTextAlign := TTextAlign.Leading;
        lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
        lbl.FontColor := $FF000000;
        lbl.Font.Size := 14;
        lbl.Height := GetLabelHeight(lbl, lv_chat.Width - 10, lbl.Text);
        altura := altura + lbl.Height;


        // Data-Hora...
        lbl2 := TLabel.Create(ListView);
        lbl2.Text := TJSONObject(JsonObj).GetValue('data').Value;
        lbl2.Align := TAlignLayout.Right;
        lbl2.StyledSettings := lbl2.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
        lbl2.Height := 13;
        lbl2.FontColor := $FFA1A1A1;
        lbl2.Font.Size := 11;
        altura := altura + lbl2.Height;



        // Balao de mensagem...
        rect := TRectangle.Create(ListView);
        rect.Align := TAlignLayout.Contents;
        rect.Fill.Kind := TBrushKind.Solid;
        rect.CornerType := TCornerType.Round;
        rect.XRadius := 10;
        rect.YRadius := 10;
        rect.Stroke.Kind := TBrushKind.None;
        rect.Padding.Top := 10;
        rect.Padding.Left := 10;
        rect.Padding.Right := 10;
        rect.Padding.Bottom := 10;
        rect.Width := GetLabelHeight(lbl, lv_chat.Width - 10, lbl.Text) ;

        if TJSONObject(JsonObj).GetValue('ind_propria').Value = 'S' then
            rect.Fill.Color := $FFDCF8C6
        else
        rect.Fill.Color := $FFFFFFFF;
        rect.AddObject(lbl2);
        rect.AddObject(lbl);
    //  rect.AddObject( btnGravacao);

        // Emb...
        emb := TListItemEmbeddedControl.Create(Item);
        emb.Width := trunc(lv_chat.Width * 0.25);
        emb.Height := altura + 10;
        emb.Name := 'emb';
        emb.PlaceOffset.Y := 10;
        emb.Container.AddObject(rect);

        //Posicão dos baloes usuario/cliente
        if TJSONObject(JsonObj).GetValue('ind_propria').Value = 'S' then
            emb.PlaceOffset.X := ListView.Width + 4 + emb.Width
        else
            emb.PlaceOffset.X := 4;
        //ajustar altura
            Item.Height := Trunc(emb.Height + 10 + 10);
    finally
        JsonObj.DisposeOf;
    end;

end;

procedure TFrm_Principal.Setup_ItemAudio(item: TListViewItem);
var
    emb: TListItemEmbeddedControl;
  btnPlay, rect: TRectangle;
  imgPlay: TRectangle;
  pgPlay: TProgressBar;
  lbl2: TLabel;

  lbl, lyPlay: TLabel;
  JsonObj: TJSONObject;
  foto_base64 :string;
  altura: single;
  lyGravacao: TLayout;
  btnGravacao: TRectangle;
  imgGravacao: TRectangle;
  lbGravacao: TLabel;
  bmp : TBitmap;
  hora:string;
begin
    Item.Height := 100;
    altura := 0;
     try
     JsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(item.TagString), 0) as TJSONObject;
        foto_base64 := fotoPlay;
        // Texto...
 // Data-Hora...
        hora:= TJSONObject(JsonObj).GetValue('data').Value;
        lbl2 := TLabel.Create(ListView);
        lbl2.Text := hora;
        lbl2.Align := TAlignLayout.Bottom;
        lbl2.StyledSettings := lbl2.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
        lbl2.Height := 13;
        lbl2.FontColor := $FFA1A1A1;
        lbl2.Font.Size := 11;
        altura := altura + lbl2.Height;
        lbl2.Align := TAlignLayout.Right;



        // Balao de mensagem...
        rect := TRectangle.Create(ListView);
        rect.Align := TAlignLayout.Contents;
        rect.Fill.Kind := TBrushKind.Solid;
        rect.CornerType := TCornerType.Round;
        rect.XRadius := 10;
        rect.YRadius := 10;
        rect.Stroke.Kind := TBrushKind.None;
        rect.Padding.Top := 10;
        rect.Padding.Left := 10;
        rect.Padding.Right := 10;
        rect.Padding.Bottom := 10;
        rect.Width := 80 ;
  {BUTTON QUE EXECUTA O ÁUDIO}
  btnPlay:= TRectangle.Create(ListView);
//  btnPlay.Name                          := 'AudBtnPlay1';
  btnPlay.Fill.Color                    := TAlphaColorRec.Seagreen;
  btnPlay.Stroke.Kind                   := TBrushKind.None;
  btnPlay.Height                        := 38; {precisa}
  btnPlay.Align                         := TAlignLayout.MostLeft;
  btnPlay.Margins                       := TBounds.Create(tRectF.Create(6, 6, 2, 6));
  btnPlay.Width                         := btnPlay.Height;
  btnPlay.Cursor                        := crHandPoint;
 // btnPlay.OnClick                       := btnPlayClick;
        bmp := BitmapFromBase64(foto_base64);
    //    proporcao := bmp.Image.Width / bmp.Image.Height;
  //imagem do botão play
  imgPlay                       := TRectangle.Create(ListView);
 // imgPlay.Name                          := 'AudImgPlay1';
  imgPlay.HitTest                       := false;
  imgPlay.Locked                        := true;
  imgPlay.Fill.Kind                     := TBrushKind.Bitmap;
  imgPlay.Fill.Bitmap.WrapMode          := TWrapMode.TileStretch;
  imgPlay.Fill.Bitmap.Bitmap            := bmp;
  imgPlay.Stroke.Kind                   := TBrushKind.None;
  imgPlay.Align                         := TAlignLayout.Left;


  {BARRA DE PROGRESSO DO ÁUDIO}
  pgplay:=TProgressBar.Create(ListView);
  pgPlay.Align                          := TAlignLayout.Left;
  pgPlay.Align                          := TAlignLayout.None;
  pgPlay.Height                         := 10;
  pgPlay.Width                          := ((btnPlay.Width - btnPlay.Width) - 8);
  pgPlay.Margins                        := TBounds.Create(tRectF.Create(4, 6, 4, 6));
  pgPlay.Value                          := 25;
  pgPlay.Position.Y                     := Trunc((btnPlay.Height / 2) - (pgPlay.Height / 2));
  pgPlay.Anchors                        := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight];


        if TJSONObject(JsonObj).GetValue('ind_propria').Value = 'S' then
            rect.Fill.Color := $FFDCF8C6
        else
        rect.Fill.Color := $FFFFFFFF;
        rect.AddObject(lbl2);
       // rect.AddObject(lbl);
        rect.AddObject(btnPlay);
        rect.AddObject(imgPlay);
        rect.AddObject(pgPlay);

         bmp.DisposeOf;
        // Emb...
        emb := TListItemEmbeddedControl.Create(Item);
        emb.Width := trunc(lv_chat.Width * 0.25);
        emb.Height := altura + 20;
        emb.Name := 'emb';
        emb.PlaceOffset.Y :=20;
        emb.Container.AddObject(rect);

        //Posicão dos baloes usuario/cliente
        if TJSONObject(JsonObj).GetValue('ind_propria').Value = 'S' then
            emb.PlaceOffset.X := ListView.Width + 4 + emb.Width
        else
            emb.PlaceOffset.X := 4;
        //ajustar altura
            Item.Height := Trunc(emb.Height + 10 + 10);
    finally
        JsonObj.DisposeOf;
    end;
end;

procedure TFrm_Principal.Setup_ItemFoto(item: TListViewItem);
var
    lbl2 : TLabel;
    JsonObj : TJSONObject;
    rect : TRectangle;
    emb : TListItemEmbeddedControl;
    altura : single;
    foto_base64 : string;
    bmp : TBitmap;
    proporcao : double;
begin
    Item.Height := 100;
    altura := 0;

    try
        JsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(item.TagString), 0) as TJSONObject;

        // Foto Base 64...
        foto_base64 := TJSONObject(JsonObj).GetValue('foto').Value;


        // Data-Hora...
        lbl2 := TLabel.Create(ListView);
        lbl2.Text := TJSONObject(JsonObj).GetValue('data').Value;
        lbl2.Align := TAlignLayout.Right;
        lbl2.StyledSettings := lbl2.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
        lbl2.Height := 13;
        lbl2.FontColor := $FFFFFFFF;
        lbl2.Font.Size := 11;
       // lbl2.Align := TAlignLayout.Right;
        altura := altura + lbl2.Height;

        // Foto...
        bmp := BitmapFromBase64(foto_base64);
        proporcao := bmp.Image.Width / bmp.Image.Height;


        // Balao de mensagem...
        rect := TRectangle.Create(ListView);
        rect.Fill.Kind := TBrushKind.Bitmap;
        rect.Fill.Bitmap.Bitmap := bmp;
        rect.Fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
        rect.Align := TAlignLayout.Contents;
        rect.CornerType := TCornerType.Round;
        rect.XRadius := 0;
        rect.YRadius := 10;
        rect.Stroke.Kind := TBrushKind.None;
        rect.Padding.Top := 10;
        rect.Padding.Left := 10;
        rect.Padding.Right := 10;
        rect.Padding.Bottom := 10;
        //  rect.Width := GetLabelHeight(lbl, lv_chat.Width - 10, lbl.Text) ;

        if TJSONObject(JsonObj).GetValue('ind_propria').Value = 'S' then
            rect.Fill.Color := $FFDCF8C6
        else
            rect.Fill.Color := $FFFFFFFF;

        rect.AddObject(lbl2);

        altura := trunc((lv_chat.Width * 0.30) / proporcao) - 2;

        bmp.DisposeOf;


        // Emb...
        emb := TListItemEmbeddedControl.Create(item);
        emb.Width := trunc(lv_chat.Width * 0.25);
        emb.Height := altura + 10;
        emb.Name := 'emb';
        emb.PlaceOffset.Y := 10;
        emb.Container.AddObject(rect);


        if TJSONObject(JsonObj).GetValue('ind_propria').Value = 'S' then
            emb.PlaceOffset.X := ListView.Width + 4 + emb.Width
        else
            emb.PlaceOffset.X := 4;

        item.Height := Trunc(emb.Height + 10 + 10);

    finally
        JsonObj.DisposeOf;
    end;

end;

procedure TFrm_Principal.lv_chatUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var

    lbl, lbl2 : TLabel;
    JsonObj : TJSONObject;
    rect : TRectangle;
    emb : TListItemEmbeddedControl;
        foto_base64 : string;
    altura : single;
begin
  AItem.Height := 100;
    altura := 0;

    try
        JsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AItem.TagString), 0) as TJSONObject;

        // Foto Base 64...
        foto_base64 := TJSONObject(JsonObj).GetValue('foto').Value;


        // Mensagem de Texto...
        if foto_base64 = '' then
            Setup_ItemTexto(Aitem)
        else
           Setup_ItemFoto(AItem);
           // Setup_ItemAudio(Aitem);

    finally
        JsonObj.DisposeOf;
    end;

end;

end.
