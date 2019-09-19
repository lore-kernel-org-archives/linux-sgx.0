Return-Path: <SRS0=SAtA=XO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86340C3A5A6
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Sep 2019 15:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58AFB21848
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Sep 2019 15:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389706AbfISPEN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Sep 2019 11:04:13 -0400
Received: from wind.enjellic.com ([76.10.64.91]:43168 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389382AbfISPEN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Sep 2019 11:04:13 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2019 11:04:12 EDT
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x8JEw5Yi012261
        for <linux-sgx@vger.kernel.org>; Thu, 19 Sep 2019 09:58:05 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x8JEw4JB012260
        for linux-sgx@vger.kernel.org; Thu, 19 Sep 2019 09:58:04 -0500
Date:   Thu, 19 Sep 2019 09:58:04 -0500
From:   "Dr. G.W. Wettstein" <greg@wind.enjellic.com>
Message-Id: <201909191458.x8JEw4JB012260@wind.enjellic.com>
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.6-ESD1.0 03/31/2012)
To:     linux-sgx@vger.kernel.org
Subject: SGX release branch.
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 19 Sep 2019 09:58:05 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Good morning, I hope the week is going well for everyone.

Apologies to the individuals that I had CC'ed on first e-mail and that
now have a dup of this e-mail.  I have been up all night and mistyped
an alias.... :-) I wanted to get this to the list at large since the
information may be presumably of interest to others.

We need to stage and maintain patches on top of what is going
upstream.  Is it correct to assume that the following branch will
ultimately be the target for the push to mainline?

jarkko-sgx/for-v23

It would be perhaps helpful for everyone if we could have a quick
summary of what the remote branches in jarkko-sgx are are targeting.

We will look forward to your reflections.

Have a good remainder of the week.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC               SGX secured infrastructure and
4206 N. 19th Ave.           autonomously self-defensive platforms.
Fargo, ND  58102
PH: 701-281-1686            EMAIL: greg@idfusion.net
------------------------------------------------------------------------------
"Simplicity is the ultimate sophistication."
                                -- Leonardo da Vinci
