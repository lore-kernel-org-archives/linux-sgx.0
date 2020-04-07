Return-Path: <SRS0=BG2U=5X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8BFC2BABC
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 09:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B82C20730
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 09:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgDGJOh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Apr 2020 05:14:37 -0400
Received: from wind.enjellic.com ([76.10.64.91]:34396 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGJOh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 7 Apr 2020 05:14:37 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0379EN6s011785;
        Tue, 7 Apr 2020 04:14:23 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0379ENR1011784;
        Tue, 7 Apr 2020 04:14:23 -0500
Date:   Tue, 7 Apr 2020 04:14:23 -0500
From:   "Dr. Greg Wettstein" <gw@idfusion.org>
To:     linux-sgx@vger.kernel.org
Cc:     serge.ayoun@intel.com, shay.katz-zamir@intel.com
Subject: [PATCH 0/1] Implement cryptographic initialization control.
Message-ID: <20200407091423.GA11749@wind.enjellic.com>
Reply-To: "Dr. Greg Wettstein" <gw@idfusion.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 07 Apr 2020 04:14:24 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Good morning, I hope the week has started well for everyone.

We had raised this issue a couple of week ago, when Jarkko commented
that he would be disinclined to change the signature of ioctl's once
they are in place.  There was no reply to that mail so we will raise
the issue again, this time with a patch.

As a preface, it is important to note that the only consumers of this
driver are the userspace SGX runtimes.  There may be some incidental
interest in individuals who dabble in SGX programming but a full
runtime is a substantive body of work and there will be a limited body
of such software.  The driver thus, primarily, needs to service the
needs of these runtimes.

In addition, since the proposed driver is built statically into the
kernel, there is no straight forward way of providing an alternative
implementation with modules.  So the driver needs to support all of
the runtime functionality needs.

Currently Intel has the reference implementation.  GOOGLE and
Microsoft are using that implementation or a modified version of it.
It is unclear what IBM/RH is using with their Enarx project, their
web-site was indicating that as of 1/1/2020, the codebase was not yet
functional, but that may have since changed.  We have a second
implementation that is compatible with the Intel implementation that
is focused on a minimal footprint implementation.  There may be a few
others banging around as well.

In order to deliver security solutions consistent with its design, SGX
needs to have the ability to implement cryptograhic initialization
policy.  There have been comments that cryptographic policies would be
considered after the driver is in the kernel.

Unfortunately, if we follow this strategy, there will inevitably be
issues surrounding the driver ABI, and based on Jarkko's comments, the
ioctl signatures.  So we need to resolve the issue before the driver
goes in.  It seems unlikely that this will delay the driver much more
then it already has been delayed.

We developed a patch on top of the current driver that implements a
framework for such policies.  This mail will be followed up with a
copy of the patch, if it gets mangled we have the patch available at
the following URL:

ftp://ftp.enjellic.com/pub/sgx/kernel/SFLC-current.patch

As the diffstat on the patch demonstrates, this infrastructure can be
implemented with virtually no impact on the driver writ large.  The
infrastructure also results in no change to the default initialization
behavior of the driver and only implements cryptographically enforced
policy at the discretion of the owner/administrator of the system.

We believe this demonstrates there is no technical reason for not
having such support in the driver.  Runtimes are free to completely
ignore the functionality as are the distributions.

We've scoped this to only the SGX list at this time before litigating
the issue on its technical merits on LKML.

Have a good day.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      SGX secured infrastructure and
Enjellic Systems Development, LLC     autonomously self-defensive
4206 N. 19th Ave.                     platforms.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"I had three strikes against me; I had a radical idea, it worked, and
 I was an outsider."
                                -- Craig Venter
