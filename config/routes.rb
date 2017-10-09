Rails.application.routes.draw do
	root 'static_pages#home'
	get 'staticpages/home'
	get 'staticpages/help'
	get 'staticpages/about'
	get 'staticpages/contact'
end
