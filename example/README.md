# clade_midtrans_example

Demonstrates how to use the clade_midtrans plugin.

## How To Integrate

### Setup Android Project

On `AndroidManifest.xml`
- add `xmlns:tools="http://schemas.android.com/tools"` on `<manifest>`
- add `tools:replace="android:label"` and `android:theme="@style/AppTheme"` on `<application>`

On `styles.xml`
- add following snippet under `<resources>`
```
    <style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
        <item name="windowNoTitle">true</item>
        <item name="windowActionBar">false</item>
    </style>
```
