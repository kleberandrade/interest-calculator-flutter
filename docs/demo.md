# Classroom demonstration

Start with `flutter run -d chrome` using Flutter 3.50.0. Present the form and its empty summary before selecting **Usar exemplo**. Ask students to calculate `1000 × 1.01² + 20` independently, then select **Calcular total** and compare the R$ 1.040,10 total and its two charges.

Change the interest period to monthly and recalculate: two overdue days become zero completed monthly periods, while the fee remains R$ 20,00. Change payment to `28/04/2024`: the 60-day interval has two completed periods. Discuss why this is a classroom convention, not a universal banking rule.

Enter `-1` for the principal and calculate. The field must show a validation error and the old result must be absent. Try `29/02/2023` to demonstrate strict calendar validation. Reset with **Limpar**, then demonstrate the calendar picker and the theme/about controls. Narrow the browser to 390px and inspect the stacked result. These are Web demonstrations, not evidence of a phone test.

For a code walkthrough, begin with integer cents and hundredths of a percent in `Slip`. Follow `parseDecimal` into the validated input, then `calculate` into the independently tested compound example. Explain why the fee is not included in the interest base and why charges are rounded separately. Run `flutter test --coverage`; use LCOV as a way to find unexecuted lines rather than a correctness certificate.

Suggested exercises: add simple interest as an explicit alternative with independent fixtures; compare completed-month and proportional-month conventions; add keyboard focus movement to the result without disrupting screen readers. Do not silently replace the existing convention or imply verified banking compliance.


## Editorial rules for future revisions

Keep the existing Medium article URL, Portuguese language and author credits. Update setup, source excerpts, cover and real interface screenshots together. Reflect the exact validated SDK and package versions, including explicit overrides and platform limitations. End the article with exactly five substantive exercises, after credits/references. Do not append an old challenge list after those exercises or present historical dependency snippets as current instructions.
