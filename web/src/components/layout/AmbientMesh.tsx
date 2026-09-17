/**
 * The colour field that sits behind every glass surface.
 *
 * `backdrop-filter` needs something to blur — without this layer the glass
 * panels degrade to flat translucent boxes. Purely decorative, so it is hidden
 * from assistive technology, and its drift animation is disabled under
 * `prefers-reduced-motion` (see index.css).
 */
export function AmbientMesh() {
  return (
    <div className="ambient-mesh" aria-hidden="true">
      <span />
      <span />
      <span />
    </div>
  )
}
