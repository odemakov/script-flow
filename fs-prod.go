// fs-prod.go
//go:build production

package main

import (
	"embed"
	"io/fs"

	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

//go:embed frontend/dist
var embeddedFiles embed.FS

// mountFs configures the embedded file system for the application's
// front-end assets when building for production.
func (sf *ScriptFlow) MountFs() {
	sf.app.OnServe().BindFunc(func(e *core.ServeEvent) error {
		fs, err := fs.Sub(embeddedFiles, "frontend/dist")
		if err != nil {
			return err
		}

		e.Router.GET("/{path...}", apis.Static(fs, true))
		return e.Next()
	})
}
