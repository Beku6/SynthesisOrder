# Synor Visual Parity Checklist

Last updated: 2026-03-25

Scope:
- Compare the Flutter implementation against the exported Synor TSX/CSS source.
- Track parity for typography, font family, weight, line height, spacing, paddings, margins, card proportions, radius, shadows, colors, icon sizing, chip/button sizing, bottom navigation fidelity, animation fidelity, dark theme consistency, and Material-style leaks.
- This document covers visual fidelity only. It does not add new product features.

Legend:
- `[x]` reviewed and aligned
- `[~]` visually aligned with a documented exception
- `[ ]` requires additional refinement

## Global
- [x] Theme/token mapping reviewed
- [x] Dark theme base surfaces reviewed
- [x] Shared segmented control reviewed
- [x] Shared search field reviewed
- [x] Shared glass panels reviewed
- [x] Shared icon button geometry reviewed
- [x] Bottom navigation reviewed
- [x] Remaining Material-style leaks removed from interactive controls

Notes:
- Custom services select styling replaced the last obvious Material-default dropdown.
- Ripple-style interaction in Settings was removed in favor of the custom press treatment.
- Shared story cards now include blur to match the export's glass treatment.

## Splash
- [x] Typography
- [x] Font family / weight
- [x] Spacing / paddings / margins
- [x] Logo proportions
- [x] Border radius / shadows
- [x] Animation pulse timing
- [x] Dark theme consistency

Notes:
- Brand mark glow and title scale were tuned to the source.

## Onboarding
- [x] Typography
- [x] Font family / weight
- [x] Line height
- [x] Spacing / paddings / margins
- [x] Floating card proportions
- [x] Radius / blur / shadows
- [x] CTA button dimensions
- [x] Pagination dots
- [x] Transition animation
- [x] Dark theme consistency

Notes:
- Bottom violet glow, floating card opacity/scale states, and step transitions were tightened against the export.

## Sign In
- [x] Typography
- [x] Font family / weight
- [x] Line height
- [x] Spacing / paddings / margins
- [x] Field dimensions
- [x] Icon sizing / alignment
- [x] Button and divider proportions
- [x] Dark theme consistency
- [x] Material-style leaks

## Sign Up
- [x] Typography
- [x] Font family / weight
- [x] Line height
- [x] Spacing / paddings / margins
- [x] Back button geometry
- [x] Progress indicator proportions
- [x] Tile / toggle dimensions
- [x] Step transition animation
- [x] Dark theme consistency
- [x] Material-style leaks

## Main Shell
- [x] Mobile container proportions
- [x] Ambient background glows
- [x] Shell glass / border treatment
- [x] Screen transition behavior
- [x] Dark theme consistency

## Bottom Navigation
- [x] Bar height / padding
- [x] Radius
- [x] Blur / glass alpha
- [x] Border color
- [x] Selected pill proportions
- [x] Selected / unselected icon sizing
- [x] Shadow fidelity
- [x] Dark theme consistency

## Home
- [x] Header typography
- [x] Logo tile sizing
- [x] Theme toggle dimensions / motion
- [x] Search field proportions
- [x] Action button geometry
- [x] Story card proportions / blur / glow
- [x] Filter chip sizing / shadows
- [x] Lesson card spacing / chips / icons
- [x] Swipe action proportions
- [x] Dark theme consistency

Notes:
- Story cards now use blur like the source.
- Swipe action labels now render in the same uppercase visual style as the export.

## Schedule
- [x] Header typography
- [x] Search button geometry
- [x] Segmented control fidelity
- [x] Day selector sizing / spacing
- [x] Timeline spacing
- [x] Week cards
- [x] Month calendar card
- [x] Month nav button geometry
- [x] Upcoming event tiles
- [x] Mode transition animation
- [x] Dark theme consistency

Notes:
- Day-chip and segmented-control shadow treatment now matches the selected-pill styling from the export more closely.

## Study Hub
- [x] Header typography
- [x] Search button geometry
- [x] Segmented control fidelity
- [x] Continue-studying cards
- [x] Assignments hierarchy
- [x] Subject cards
- [x] Exam cards
- [x] Weak-topic section
- [x] Mode transition animation
- [x] Dark theme consistency

Notes:
- Restored the missing `See all` section hierarchy from the export.

## Services Main
- [x] Header typography
- [x] Search field proportions
- [x] Service grid card proportions
- [x] Recent requests hierarchy
- [x] Status chip fidelity
- [x] Dark theme consistency

## Services Documents
- [x] Sticky header styling
- [x] Back button geometry
- [x] Card proportions
- [x] Add button sizing
- [x] Dark theme consistency

## Services Payments
- [x] Sticky header styling
- [x] Balance card gradient / bubble treatment
- [x] Fee card spacing
- [x] CTA proportions
- [x] Dark theme consistency

## Services Housing
- [x] Sticky header styling
- [x] Dorm card proportions
- [x] Form label typography
- [x] Select field fidelity
- [x] Text field proportions
- [x] CTA proportions
- [x] Material-style leaks removed
- [x] Dark theme consistency

## Services Support
- [x] Sticky header styling
- [x] Shortcut card colors / icon surfaces
- [x] Form hierarchy
- [x] CTA proportions
- [x] Dark theme consistency

## Services All Requests
- [x] Sticky header styling
- [x] Request tile proportions
- [x] Status chip fidelity
- [x] Dark theme consistency

## Smart Alarm
- [x] Header hierarchy
- [x] Back button geometry
- [x] Mode toggle fidelity
- [x] Academic type chips
- [x] Time picker proportions
- [x] CTA proportions
- [x] Dark theme consistency

## Messages
- [x] Header hierarchy
- [x] Back button geometry
- [x] Title alignment
- [x] Message tile proportions
- [x] Avatar sizing / alignment
- [x] Dark theme consistency

## Profile
- [x] Cover proportions
- [x] Cover bottom radius
- [x] Cover action button glass treatment
- [x] Avatar overlap / glow / status indicator
- [x] Name / subtitle typography
- [x] Tag sizing
- [x] Quick action button dimensions
- [x] Current status section typography
- [x] Signal chip proportions
- [x] Stats / activity / row groups
- [x] Bottom spacing against nav
- [x] Dark theme consistency

Notes:
- Cover overlap and rounded lower edge were corrected to match the export more closely.

## Settings Overlay
- [x] Header surface / border
- [x] Back button geometry
- [x] Profile card proportions
- [x] Section caption typography
- [x] Row spacing / weights
- [x] Toggle proportions
- [x] Logout button treatment
- [x] Material-style leaks removed
- [x] Dark theme consistency

## Edit Cover Overlay
- [x] Sheet radius
- [x] Header blur / alpha / border
- [x] Close button geometry
- [x] Upload card hierarchy
- [x] Template grid proportions
- [x] Selection state fidelity
- [x] Dark theme consistency

## Quick Alert Sheet
- [x] Sheet radius / handle
- [x] Header spacing
- [x] Preset row proportions
- [x] Button hierarchy
- [x] Dark theme consistency

## Service Request Details
- [x] Sheet radius / handle
- [x] Header block proportions
- [x] Info row typography
- [x] CTA sizing
- [x] Dark theme consistency

## Service Success Modal
- [x] Scrim blur
- [x] Scale / fade animation
- [x] Icon block proportions
- [x] Typography
- [x] Dark theme consistency

## Known Visual Exceptions
- [~] The original exported `graduation` cover asset is unavailable because the source URL returned `404`; a similar local graduation image is used in its place.
- [~] Hover-only desktop microinteractions from the export are adapted for touch where necessary, especially around the Profile cover actions.
