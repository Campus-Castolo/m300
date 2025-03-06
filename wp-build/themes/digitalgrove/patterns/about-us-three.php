<?php
/**
 * Title: About Us Three
 * Slug: digitalgrove/about-us-three
 * Categories: digitalgrove
 * Keywords: about-us
 * Block Types: core/post-content
 * Post Types: page, wp_template
 */
?>
<!-- wp:group {"style":{"spacing":{"margin":{"top":"0","bottom":"0"},"padding":{"top":"var:preset|spacing|50","bottom":"var:preset|spacing|50","left":"var:preset|spacing|20","right":"var:preset|spacing|20"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-group" style="margin-top:0;margin-bottom:0;padding-top:var(--wp--preset--spacing--50);padding-right:var(--wp--preset--spacing--20);padding-bottom:var(--wp--preset--spacing--50);padding-left:var(--wp--preset--spacing--20)"><!-- wp:columns {"verticalAlignment":"center","align":"wide","style":{"spacing":{"blockGap":{"left":"var:preset|spacing|40"}}}} -->
<div class="wp-block-columns alignwide are-vertically-aligned-center"><!-- wp:column {"verticalAlignment":"center"} -->
<div class="wp-block-column is-vertically-aligned-center"><!-- wp:image {"id":750,"aspectRatio":"1","scale":"cover","sizeSlug":"full","linkDestination":"none","style":{"border":{"radius":"10px"}}} -->
<figure class="wp-block-image size-full has-custom-border"><img src="<?php echo esc_url( get_template_directory_uri() );?>/assets/images/banner.jpg" alt="" class="wp-image-750" style="border-radius:10px;aspect-ratio:1;object-fit:cover"/></figure>
<!-- /wp:image --></div>
<!-- /wp:column -->

<!-- wp:column {"verticalAlignment":"center"} -->
<div class="wp-block-column is-vertically-aligned-center"><!-- wp:heading {"align":"wide","style":{"typography":{"lineHeight":"1.2"}}} -->
<h2 class="wp-block-heading alignwide" style="line-height:1.2"><?php echo esc_html__( 'Why We Are Best ?', 'digitalgrove' ); ?></h2>
<!-- /wp:heading -->

<!-- wp:paragraph {"style":{"spacing":{"margin":{"top":"var:preset|spacing|30","bottom":"var:preset|spacing|10"}}}} -->
<p style="margin-top:var(--wp--preset--spacing--30);margin-bottom:var(--wp--preset--spacing--10)"><?php echo esc_html__( 'Dis elit vehicula gravida pellentesque nullam risus odio augue tellus. Dictum euismod posuere velit pellentesque pulvinar. Aptent arcu metus sit congue pede. Dolor elementum proin etiam aenean consectetuer. Mollis erat risus accumsan donec senectus in mauris potenti euismod diam et. Rhoncus nisl eros per sagittis dui cubilia augue.', 'digitalgrove' ); ?></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph {"style":{"spacing":{"margin":{"bottom":"var:preset|spacing|30"}}}} -->
<p style="margin-bottom:var(--wp--preset--spacing--30)"><?php echo esc_html__( 'Congue duis quam eu iaculis tristique mus curae elit torquent suscipit. Nullam rutrum dapibus potenti platea conubia diam id maecenas nisi suscipit accumsan.', 'digitalgrove' ); ?></p>
<!-- /wp:paragraph -->

<!-- wp:buttons {"style":{"spacing":{"padding":{"right":"0","left":"0"}}}} -->
<div class="wp-block-buttons" style="padding-right:0;padding-left:0"><!-- wp:button {"className":"btn-has-icon","style":{"spacing":{"padding":{"left":"var:preset|spacing|40","right":"var:preset|spacing|40"}}}} -->
<div class="wp-block-button btn-has-icon"><a class="wp-block-button__link wp-element-button" style="padding-right:var(--wp--preset--spacing--40);padding-left:var(--wp--preset--spacing--40)"><?php echo esc_html__( 'Meet us', 'digitalgrove' ); ?></a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons --></div>
<!-- /wp:column --></div>
<!-- /wp:columns --></div>
<!-- /wp:group -->