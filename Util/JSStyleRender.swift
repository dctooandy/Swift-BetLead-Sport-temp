//
// Created on 2018/7/24.
//

import Foundation

struct JSStyleRender {
    static let share = JSStyleRender()
    
//    private let ckStyleLink = """
//    <link href="\(JSStyleRender.ckStyleLinkStr)" rel="stylesheet">
//    """
//    private let renderContentLink = """
//    <link href="\(JSStyleRender.renderContentLinkStr)" rel="stylesheet">
//    """
    
    
//    private let ckStyleLink = """
//    <link href="/Constant/Utils/ckStyle.css" rel="stylesheet">
//    """
//    private let renderContentLink = """
//    <link href="/Constant/Utils/renderContentLink.css" rel="stylesheet">
//    """
    
    private let JAVASCRIPT_IMAGE_CLICK = """
    <script type="text/javascript">
       function registerImageClickAction() {
         var imgs = document.getElementsByTagName('img');
         var length = imgs.length;

         for (var i = 0; i < length; i++) {
           var img = imgs[i];
           img.onclick=function() {
             window.location.href = 'image-preview:' + this.src;
           }
         }
       }
       registerImageClickAction();
   </script>
   """
    
    func renderFitContentCss(content:String) -> String {
        return """
        <html>
        <head>
        <style>
        \(JSStyleRender.ckStyleLinkStr)
        \(JSStyleRender.renderContentLinkStr)
        </style>
        <meta name="viewport" content="user-scalable=no,width=device-width,initial-scale=1.0,shrink-to-fit=no">
        </head>
        <body>
        <div class="render-content">
        \(content)
        </div>
        \(JAVASCRIPT_IMAGE_CLICK)
        </body>
        </html>
        """
    }
    
    static let ckStyleLinkStr = """
    .ckstyle-highlight-red {
  color: #c62828 !important;
 }

 .ckstyle-highlight-pink {
  color: #ad1457 !important;
 }

 .ckstyle-highlight-purple {
  color: #6a1b9a !important;
 }

 .ckstyle-highlight-indigo {
  color: #283593 !important;
 }

 .ckstyle-highlight-blue {
  color: #1565c0 !important;
 }

 .ckstyle-highlight-light-blue {
  color: #0277bd !important;
 }

 .ckstyle-highlight-teal {
  color: #00695c !important;
 }

 .ckstyle-highlight-green {
  color: #2e7d32 !important;
 }

 .ckstyle-highlight-light-green {
  color: #558b2f !important;
 }

 .ckstyle-highlight-lime {
  color: #558b2f !important;
 }

 .ckstyle-highlight-yellow {
  color: #f9a825 !important;
 }

 .ckstyle-highlight-amber {
  color: #f9a825 !important;
 }

 .ckstyle-highlight-orange {
  color: #ef6c00 !important;
 }

 .ckstyle-highlight-deep-orange {
  color: #d84315 !important;
 }

 .ckstyle-highlight-brown {
  color: #4e342e !important;
 }

 .ckstyle-highlight-grey {
  color: #424242 !important;
 }

 .ckstyle-highlight-blue-grey {
  color: #37474f !important;
 }
 """
    
    static let renderContentLinkStr = """
    .render-content h1, .render-content h1.render-content-h1 {
  font-size: 2em;
  font-weight: bold;
  color: #212121;
}

.render-content h2, .render-content h2.render-content-h2 {
  font-size: 1.5em;
  font-weight: bold;
  color: #212121;
}

.render-content h3, .render-content h3.render-content-h3 {
  font-size: 1.17em;
  font-weight: bold;
  color: #212121;
}

.render-content p {
  color: #616161;
  font-size: 16px;
  letter-spacing: 0.4px;
}

@media (min-width: 992px) {
  .render-content p {
    font-size: 18px;
    letter-spacing: 0.5px;
  }
}

@media (min-width: 992px) {
  .render-content p.render-content-body-2 {
    font-size: 16px;
  }
}

.render-content figure figcaption {
  font-size: 12px;
  font-weight: 600;
  line-height: 1.5;
  color: #757575;
  padding-top: 6px;
  padding-bottom: 12px;
  border-bottom: 1px dotted #9E9E9E;
}

.render-content {
  max-width: 720px;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
  "Helvetica Neue", Arial, "MsJengHeiFix", "Microsoft JhengHei", sans-serif, "Apple Color Emoji",
  "Segoe UI Emoji", "Segoe UI Symbol";
}

@media (min-width: 768px) {
  .render-content {
    max-width: 100%;
  }
}

@media (min-width: 992px) {
  .render-content {
    max-width: 800px;
  }
}

.render-content iframe {
  margin-left: auto;
  margin-right: auto;
  display: block;
  max-width: 100% !important;
}

.render-content .twitter-tweet-rendered {
  margin-left: auto;
  margin-right: auto;
}

.render-content p img, .render-content a img, .render-content figure img, .render-content div img {
  display: block;
  max-width: 100% !important;
  height: auto !important;
  margin-left: auto !important;
  margin-right: auto !important;
}

.render-content p a {
  word-break: break-word;
  color: #0d47a1;
  text-decoration: none;
  -webkit-transition: color .3s ease;
  transition: color .3s ease;
}

@media (min-width: 992px) {
  .render-content p a:hover {
    text-decoration: underline;
    color: #0071bc;
  }
}

.render-content blockquote {
  font-style: italic;
  padding: 2px 8px 2px 20px;
  border-style: solid;
  border-color: #E0E0E0;
  border-width: 0;
  border-left-width: 5px;
  margin: 1em 40px;
}

@media (max-width: 575.99px) {
  .render-content blockquote {
    margin: 1em 20px;
  }
}

.render-content p {
  margin: 0;
}

.render-content figure {
  display: inline-block;
}

.render-content figure figcaption {
  text-align: center;
}

.render-content ul, .render-content ol, .render-content li {
  list-style: inherit;
}

.render-content table {
  border-spacing: 0;
  width: 100% !important;
}

.render-content td {
  border-spacing: 0;
  max-width: 100%;
  word-wrap: break-word;
  word-break: break-all;
}

.render-content table tr {
  max-width: 100%;
}

.render-content table tr td {
  max-width: 50%;
}

.render-content table tr td img {
  max-width: 100%;
  height: auto !important;
}
"""
    
}
