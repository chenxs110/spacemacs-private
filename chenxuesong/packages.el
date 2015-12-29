;;; packages.el --- chenxuesong Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq chenxuesong-packages
      '(
        ;; package names go here
        ;; quack
        ;; geiser
        elfeed
        ycmd
        ;; ncompany-irony
        ;; irony-mode
        magit
        magit-popup
        org-octopress
        ivy-mode
        swiper
        keyfreq
        ))

;; List of packages to exclude.
(setq chenxuesong-excluded-packages '())

;; (defun chenxuesong/init-quack ()
;;   "Initialize quack"
;;   (use-package quack)
;;   )

;; (defun chenxuesong/init-geiser ()
;;   "Initialize geiser"
;;   (use-package geiser
;;     :init
;;     (progn
;;       (add-hook 'scheme-mode-hook 'geiser-mode)
;;       (setq geiser-active-implementations '(racket))
;;       )))

(defun chenxuesong/post-init-ycmd()
  (set-variable 'ycmd-server-command '("python"))
  (add-to-list 'ycmd-server-command (expand-file-name "~/emacs/ycmd/ycmd/__main__.py") t)
  ;;(set-variable 'ycmd-global-config "/Users/chenxuesong/emacs/ycmd/cpp/ycm/.ycm_extra_conf.py")
  (set-variable 'ycmd-extra-conf-whitelist '("~/Work/project/artisan-cocoslib/*"
                                             "/Users/chenxuesong/Work/project/gamesdk/cocos2d-x-3.8/artisan/Artisan/cocos2d/external/artisan-cocoslib/*"))
  (setq company-backends-c-mode-common '((company-c-headers
                                          company-dabbrev-code
                                          company-keywords
                                          company-gtags :with company-yasnippet)
                                         company-files company-dabbrev ))
  (evil-leader/set-key-for-mode 'c-mode
    "mtb" 'company-ycmd)
  (evil-leader/set-key-for-mode 'c++-mode
    "mtb" 'company-ycmd)
  )

(defun chenxuesong/post-init-magit()
  (with-eval-after-load 'magit-popup
    (magit-define-popup-action 'magit-commit-popup
      ?r "Rbt post -g" 'chenxuesong-review-code-post-g)
    (magit-define-popup-action 'magit-commit-popup
      ?R "Rbt post -r" 'chenxuesong-review-code-post-r)
    (magit-define-popup-action 'magit-commit-popup
      ?o "Rbt open" 'chenxuesong-review-code-open)
    (magit-define-popup-action 'magit-commit-popup
      ?d "Rbt diff" 'chenxuesong-review-code-diff)
    )
  )

(defun chenxuesong/init-swiper ()
  "Initialize my package"
  (use-package swiper
    :init
    (progn
      (setq ivy-use-virtual-buffers t)
      (setq ivy-display-style 'fancy)
      (with-eval-after-load 'recentf
        (setq recentf-exclude
              '("COMMIT_MSG" "COMMIT_EDITMSG" "github.*txt$"
                ".*png$"))
        (setq recentf-max-saved-items 60))
      (evilify ivy-occur-mode ivy-occur-mode-map)
      (use-package ivy
        :defer t
        :config
        (progn
          (spacemacs|hide-lighter ivy-mode)
          (define-key ivy-minibuffer-map (kbd "C-c o") 'ivy-occur)
          (define-key ivy-minibuffer-map (kbd "s-o") 'ivy-dispatching-done)
          (define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
          (define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)))

      (define-key global-map (kbd "C-s") 'swiper)
      (ivy-mode t)
      (evil-leader/set-key (kbd "bb") 'ivy-switch-buffer)
      (global-set-key (kbd "C-c C-r") 'ivy-resume)
      (global-set-key (kbd "C-c j") 'counsel-git-grep))))

(defun chenxuesong/init-keyfreq ()
  (use-package keyfreq
    :init
    (progn
      (keyfreq-mode t)
      (keyfreq-autosave-mode 1))))

(defun chenxuesong/init-org-octopress ()
  (use-package org-octopress
    :init
    (progn
      ;;(evilified-state-evilify org-octopress-summary-mode org-octopress-summary-mode-map)
      (add-hook 'org-octopress-summary-mode-hook
                #'(lambda () (local-set-key (kbd "q") 'bury-buffer)))
      (setq org-blog-dir "~/Work/blog/")
      (setq org-octopress-directory-top org-blog-dir)
      (setq org-octopress-directory-posts (concat org-blog-dir "source/_posts"))
      (setq org-octopress-directory-org-top org-blog-dir)
      (setq org-octopress-directory-org-posts (concat org-blog-dir "blog"))
      (setq org-octopress-setup-file (concat org-blog-dir "setupfile.org"))
 
      (defun chenxuesong/org-save-and-export ()
        (interactive)
        (org-octopress-setup-publish-project)
        (org-publish-project "octopress" t))

      (defun chenxuesong/org-create-org-blog-file (title category tags)
        (interactive "sOrg blog file name? \nsBlog category? \nsBlog tags <space split>? ")
        (find-file (concat org-octopress-directory-org-posts "/" (format-time-string "%Y-%m-%d") "-" title ".org"))
        (insert (concat "#+JEKYLL_CATEGORIES: " category "\n"))
        (insert (concat "#+JEKYLL_TAGS: " tags "\n"))
        (insert "#+JEKYLL_COMMENTS: true")
        )
      (evil-leader/set-key "oc" 'chenxuesong/org-create-org-blog-file)
      (evil-leader/set-key "op" 'chenxuesong/org-save-and-export)
      (evil-leader/set-key "od" 'chenxuesong-hexo-deploy)
      (evil-leader/set-key "og" 'chenxuesong-hexo-generate)
      (evil-leader/set-key "ol" 'chenxuesong-insert-qiniu-link)
      )))

(defun chenxuesong/init-elfeed()
  (use-package elfeed
    :defer t
    :config
    (progn
      (global-set-key (kbd "C-x w") 'elfeed)
      (setq elfeed-feeds
            '(
              ("http://nullprogram.com/feed/" emacs blog)
              ("http://z.caudate.me/rss/" unknown)
              ("http://tonybai.com/feed/" dev)
              ("http://planet.emacsen.org/atom.xml" emacs)
              ("http://feeds.feedburner.com/emacsblog" emacs)
              ("http://blog.binchen.org/rss.xml" emacs blog)
              ("http://oremacs.com/atom.xml" emacs)
              ("http://blog.gemserk.com/feed/" emacs)
              ("http://t-machine.org/index.php/feed/" dev)
              ("http://feeds.feedburner.com/ruanyifeng" dev blog)
              ("http://coolshell.cn/feed" dev)
              ("http://blog.devtang.com/atom.xml" dev blog)
              ("http://emacsist.com/rss" emacs)
              ("http://puntoblogspot.blogspot.com/feeds/2507074905876002529/comments/default" dev)
              ("http://xahlee.info/comp/blog.xml" emacs blog)
              ("http://www.matrix67.com/blog/feed" dev blog)
              ;; "http://feeds2.feedburner.com/cnbeta_full"
              ("http://feeds.feedburner.com/hacker-news-feed-200" news)
              ;; "http://feeds.feedburner.com/zhihu-daily"
              ("http://www.udpwork.com/feed" dev blog)
              ("http://www.reactnative.com/rss/" dev)
              ;; "http://www.zhihu.com/rss"
              ("http://ergoemacs.org/emacs/blog.xml" emacs)
              ("http://www.36kr.com/feed" news)
              ("http://feeds2.feedburner.com/programthink" dev)
              ("http://code.tutsplus.com/posts.atom" dev)
              ("http://www.infoworld.com/blog/open-sources/index.rss" news)
              ("http://www.infoworld.com/category/application-development/index.rss" news)
              ("http://www.itworld.com/news/index.rss" news))
            )

      ;; (evilify elfeed-search-mode elfeed-search-mode-map)

      (defface elfeed-emacs
        '((t :foreground "#8470FF"))
        "Marks Emacs in Elfeed."
        :group 'elfeed)

      (push '(emacs elfeed-emacs)
            elfeed-search-face-alist)

      (defface elfeed-dev
        '((t :foreground "#1E90FF"))
        "Marks Dev in Elfeed."
        :group 'elfeed)

      (push '(dev elfeed-dev)
            elfeed-search-face-alist)

      (defface elfeed-news
        '((t :foreground "#EE6363"))
        "Marks News in Elfeed."
        :group 'elfeed)

      (push '(news elfeed-news)
            elfeed-search-face-alist)

      (defface elfeed-unread
        '((t :bold t))
        "Face used in search mode for unread entry titles."
        :group 'elfeed)

      (push '(unread elfeed-unread)
            elfeed-search-face-alist)

      (setq-default elfeed-search-filter "@2-months-ago +unread ")
      (spacemacs|evilify-map elfeed-search-mode-map
        :mode elfeed-search-mode
        :bindings
        "G" 'elfeed-update
        "g" 'elfeed-search-update--force)

      (defun elfeed-export-link ()
        (interactive)
        (generate-new-buffer-name "elfeed-export")
        (save-excursion
          (mark-whole-buffer)
          (let ((entries (elfeed-search-selected)))
            (switch-to-buffer "elfeed-export")
            (cl-loop for entry in entries
                     when (elfeed-entry-link entry)
                     do (
                         (lambda ()
                           (print (elfeed-entry-title entry)
                                  (get-buffer "elfeed-export"))
                           (insert (elfeed-entry-link entry))
                           (insert "\n"))))
            )
          )
        )

      (defun elfeed-mark-all-as-read ()
        (interactive)
        (mark-whole-buffer)
        (elfeed-search-untag-all-unread))

      (define-key elfeed-search-mode-map (kbd "R") 'elfeed-mark-all-as-read)
      (define-key elfeed-search-mode-map (kbd "o") 'elfeed-export-link)

      (defadvice elfeed-show-yank (after elfeed-show-yank-to-kill-ring activate compile)
        "Insert the yanked text from x-selection to kill ring"
        (kill-new (x-get-selection)))

      (ad-activate 'elfeed-show-yank)
      )
    )
  )

(defun custom-persp/agenda ()
  (interactive)
  (custom-persp "agenda"
                (progn
                  (find-file "~/org/work.org")
                  )))

(defun custom-persp/learn-xahlee-blog ()
  (interactive)
  (custom-persp "ewwxahlee"
                (progn
                  (eww-open-file "~/Work/Emacs/Document/xahemacs20150606/xah_emacs_tutorial/index.html")
                  )))



;; For each package, define a function chenxuesong/init-<package-name>
;;
;; (defun chenxuesong/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
