<?php


/**
 * DigitalGrove functions and definitions
 *
 * @link https://developer.wordpress.org/themes/basics/theme-functions/
 *
 * @subpackage DigitalGrove
 * @since DigitalGrove 1.0
 */

 if (!function_exists('digitalgrove_support')) :

    /**
     * Sets up theme defaults and registers support for various WordPress features.
     *
     * @since walker_fse 1.0.0
     *
     * @return void
     */
    function digitalgrove_support()
    {
        // Add default posts and comments RSS feed links to head.
        add_theme_support('automatic-feed-links');
        add_theme_support('post-thumbnails');        
        //post format support
        add_theme_support( 'post-formats', array('gallery', 'image', 'video', 'audio') );

    }

endif;
add_action('after_setup_theme', 'digitalgrove_support');

 function digitalgrove_block_assets(){
    // Enqueue theme stylesheet for the front-end.
    wp_enqueue_style( 'digitalgrove-style', get_template_directory_uri() . '/style.css', array(), wp_get_theme()->get( 'Version' ) );
	wp_enqueue_style( 'fontawesome', get_template_directory_uri() . '/assets/font-awesome/css/all.css', array(), '5.15.3' );
	wp_enqueue_style( 'animatecss', get_template_directory_uri() . '/assets/css/animate.css');
	wp_enqueue_script('wow-script', get_template_directory_uri() . '/assets/js/wow.js', array('jquery'));
	wp_enqueue_script('main-script', get_template_directory_uri() . '/assets/js/script.js', array('jquery'), '1.0.0', true);
	wp_enqueue_script('jquery-sticky', get_template_directory_uri() . '/assets/js/jquery-sticky.js', array('jquery') );    
}

add_action('enqueue_block_assets', 'digitalgrove_block_assets');

// register own theme pattern

function digitalgrove_register_pattern_category() {

	$patterns = array();

	$block_pattern_categories = array(
		'digitalgrove' => array( 'label' => __( 'DigitalGrove', 'digitalgrove' ) )
	);

	$block_pattern_categories = apply_filters( 'digitalgrove_block_pattern_categories', $block_pattern_categories );

	foreach ( $block_pattern_categories as $name => $properties ) {
		if ( ! WP_Block_Pattern_Categories_Registry::get_instance()->is_registered( $name ) ) {
			register_block_pattern_category( $name, $properties );
		}
	}
}

add_action( 'init', 'digitalgrove_register_pattern_category');

// Admin Info
require get_template_directory() . '/class/admin-info.php';