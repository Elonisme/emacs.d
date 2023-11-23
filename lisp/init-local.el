;;; init-local.el --- Load the my configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:


;; 安装 `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; 配置 `use-package'
(eval-and-compile
  (setq use-package-always-ensure nil)
  (setq use-package-always-defer nil)
  (setq use-package-expand-minimally nil)
  (setq use-package-enable-imenu-support t)
  (if (daemonp)
      (setq use-package-always-demand t)))

(eval-when-compile
  (require 'use-package))

;; 安装 `use-package' 的集成模块
(use-package use-package-ensure-system-package
  :ensure t)
(use-package diminish
  :ensure t)
(use-package bind-key
  :ensure t)

;;; treesit
(use-package treesit-auto
  :ensure t
  :config
  (global-treesit-auto-mode))

;;; 设置Dashboard
(use-package dashboard
  :ensure t
  :init
  (progn
    ;; Set the title
    (setq dashboard-banner-logo-title "Welcom Inkwell Emacs")
    ;; Set the banner
    (setq dashboard-startup-banner "/home/elon/.emacs.d/logo.png")
    ;; Content is not centered by default. To center, set
    (setq dashboard-center-content t)
    (setq dashboard-display-icons-p t) ;; display icons on both GUI and terminal
    (setq dashboard-icon-type 'nerd-icons) ;; use `nerd-icons' package
    (setq dashboard-set-heading-icons t)
    (setq dashboard-set-file-icons t)
    )
  :config
  (dashboard-setup-startup-hook)

  ;; Customize the dashboard items
  (setq dashboard-items '((recents . 6)
                          (bookmarks . 6)
                          ))
  )

(use-package nerd-icons   
	     :ensure t   
	     :if (display-graphic-p)   
	     )
	
(use-package all-the-icons   
	     :ensure t   
	     :if (display-graphic-p)
	     )



;;; 设置卡片笔记为文献笔记的搭建做准备
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "/home/elon/Documents/Note/Org-Roam"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n u" . org-roam-ui-open)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package org-roam-ui
  :ensure t
  :after org-roam
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow-mode t)
  )


;;; 为写笔记提供便利
;; 使用xelatex，配合当前org文件最开始的配置来正常输出中文
(setq org-latex-pdf-process
      '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;; org-download实现粘贴复制图片到orgmode
(use-package org-download
  :ensure t
  :defer t ;; 延迟加载
  :bind
  (:map org-mode-map
        ("C-M-y" . org-download-clipboard)) ;; 绑定从剪贴版粘贴截图的快捷键
  :custom
  (org-download-heading-lvl 1) ;; 用一级标题给截图文件命名
  :config
  (setq-default org-download-image-dir "./img")) ;; 用同级 ./img 目录放置截图文件
(add-hook 'dired-mode-hook 'org-download-enable)

;; 为org mode显示数学公式
(use-package texfrag
  :ensure t
  :hook (org-mode . texfrag-mode)
  :config
  (setq texfrag-extensions '("pdf"))
  (setq texfrag-dpi 900))

;; 自动刷新数学公式
(use-package org-fragtog
  :ensure t
  :after org
  :hook
  (org-mode . org-fragtog-mode))

;; Latex设置
(use-package cdlatex
  :ensure t
  :defer t
  :config
  (add-hook 'org-mode-hook 'org-cdlatex-mode)
  ) ;; 在 LaTeX 模式下自动开启 cdlatex


(use-package tex
  :ensure auctex
  :custom
  (TeX-parse-self t) ; 自动解析 tex 文件
  (TeX-PDF-mode t)
  (TeX-DVI-via-PDFTeX t)
  :config
  (setq-default TeX-master t) ; 默认询问主文件
  (setq TeX-source-correlate-mode t) ;; 编译后开启正反向搜索
  (setq TeX-source-correlate-method 'synctex) ;; 正反向搜索的执行方式
  (setq TeX-source-correlate-start-server t) ;; 不再询问是否开启服务器以执行反向搜索
  ;;;LaTeX config
  (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex -shell-escape --synctex=1%(mode)%' %t" TeX-run-TeX nil t))
  ) ; 加载LaTeX模式钩子

;; 图片默认宽度
(setq org-image-actual-width '(400))

(provide 'init-local)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
;;; init-local.el ends here
