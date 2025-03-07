import { RichText } from "@wordpress/block-editor";
import {
    EBDisplayIcon,
    sanitizeURL,
    BlockProps
} from "@essential-blocks/controls";

const save = ({ attributes }) => {
    const {
        blockId,
        showIcon,
        icon,
        title,
        titleTag,
        showSubtitle,
        subtitle,
        description,
        buttonText,
        buttonURL,
        sortableLists,
        buttonSize,
        btnHoverEffect,
        showButton,
        classHook,
        linkNewTab,
        subtitleTag
    } = attributes;
    return (
        <BlockProps.Save
            attributes={attributes}
        >
            <div className={`eb-parent-wrapper eb-parent-${blockId} ${classHook}`}>
                <div
                    className={`eb-cia-wrapper ${blockId}`}
                    data-icon={icon ? icon : ""}
                >
                    <div className="eb-cia-text-wrapper">
                        {sortableLists.map(({ label, value }, index) => {
                            if (value === "title") {
                                return (
                                    <RichText.Content
                                        key={index}
                                        tagName={titleTag}
                                        className="eb-cia-title"
                                        value={title}
                                    />
                                );
                            } else if (value === "subtitle") {
                                return (
                                    showSubtitle && (
                                        <RichText.Content
                                            key={index}
                                            tagName={subtitleTag}
                                            className="eb-cia-subtitle"
                                            value={subtitle}
                                        />
                                    )
                                );
                            } else if (value === "icon") {
                                return (
                                    showIcon && (
                                        <EBDisplayIcon className="eb-cia-icon" icon={icon} />
                                    )
                                );
                            } else if (value === "description") {
                                return (
                                    <RichText.Content
                                        key={index}
                                        tagName="p"
                                        className="eb-cia-description"
                                        value={description}
                                    />
                                );
                            }
                        })}
                    </div>
                    {showButton && (
                        <div className="eb-cia-button-wrapper">
                            <a
                                href={buttonURL == undefined ? '' : sanitizeURL(buttonURL)}
                                target={linkNewTab ? "_blank" : "_self"}
                                rel="noopener"
                            >
                                <div
                                    className={`eb-cia-button is-${buttonSize}${btnHoverEffect ? ` ${btnHoverEffect}` : ""
                                        }`}
                                >
                                    <RichText.Content value={buttonText} />
                                </div>
                            </a>
                        </div>
                    )}
                </div>
            </div>
        </BlockProps.Save>
    );
};

export default save;
