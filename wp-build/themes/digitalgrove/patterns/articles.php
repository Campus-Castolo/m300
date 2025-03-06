<?php
/**
 * Title: Articles
 * Slug: digitalgrove/articles
 * Categories: digitalgrove
 * Keywords: articles
 * Block Types: core/post-content
 * Post Types: page, wp_template
 */
?>
<!-- wp:group {"metadata":{"categories":["digitalgrove"],"patternName":"digitalgrove/articles","name":"Articles"},"style":{"spacing":{"margin":{"top":"0","bottom":"0"},"padding":{"top":"var:preset|spacing|50","bottom":"var:preset|spacing|50","left":"var:preset|spacing|20","right":"var:preset|spacing|20"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-group" style="margin-top:0;margin-bottom:0;padding-top:var(--wp--preset--spacing--50);padding-right:var(--wp--preset--spacing--20);padding-bottom:var(--wp--preset--spacing--50);padding-left:var(--wp--preset--spacing--20)"><!-- wp:paragraph {"align":"center","style":{"typography":{"lineHeight":"1.5"},"elements":{"link":{"color":{"text":"var:preset|color|primary"}}}},"textColor":"primary"} -->
<p class="has-text-align-center has-primary-color has-text-color has-link-color" style="line-height:1.5"><?php echo esc_html__( 'Blog', 'digitalgrove' ); ?></p>
<!-- /wp:paragraph -->

<!-- wp:heading {"textAlign":"center","style":{"typography":{"lineHeight":"1.2"},"spacing":{"margin":{"top":"10px","bottom":"80px"}}}} -->
<h2 class="wp-block-heading has-text-align-center" style="margin-top:10px;margin-bottom:80px;line-height:1.2"><?php echo esc_html__( 'Browse Articles', 'digitalgrove' ); ?></h2>
<!-- /wp:heading -->

<!-- wp:query {"queryId":10,"query":{"perPage":3,"pages":0,"offset":0,"postType":"post","order":"desc","orderBy":"date","author":"","search":"","exclude":[],"sticky":"","inherit":false,"parents":[],"format":[]}} -->
<div class="wp-block-query"><!-- wp:post-template {"style":{"spacing":{"blockGap":"var:preset|spacing|30"}},"layout":{"type":"grid","columnCount":3}} -->
<!-- wp:post-featured-image {"style":{"border":{"radius":"10px"}}} /-->

<!-- wp:group {"style":{"spacing":{"margin":{"top":"var:preset|spacing|20"}}},"layout":{"type":"flex","flexWrap":"wrap","justifyContent":"space-between"}} -->
<div class="wp-block-group" style="margin-top:var(--wp--preset--spacing--20)"><!-- wp:post-author {"showAvatar":false} /-->

<!-- wp:post-date /--></div>
<!-- /wp:group -->

<!-- wp:post-title {"level":3,"isLink":true,"style":{"typography":{"lineHeight":"1.5"},"spacing":{"margin":{"top":"var:preset|spacing|10"}}},"fontSize":"mdm-large"} /-->

<!-- wp:read-more {"style":{"elements":{"link":{"color":{"text":"var:preset|color|primary"}}}},"textColor":"primary"} /-->
<!-- /wp:post-template --></div>
<!-- /wp:query --></div>
<!-- /wp:group -->