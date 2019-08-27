Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF72C3A59F
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 01:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 331EE217F5
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 01:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbfH0BUt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 21:20:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:59971 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbfH0BUt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 21:20:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 18:20:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,435,1559545200"; 
   d="scan'208";a="187766297"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Aug 2019 18:20:49 -0700
Date:   Mon, 26 Aug 2019 18:20:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] x86/sgx: Pass userspace source address directly to EADD
Message-ID: <20190827012049.GB25260@linux.intel.com>
References: <20190823021009.3880-1-sean.j.christopherson@intel.com>
 <20190826063206.hx3gk7ma5f2qa6uc@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826063206.hx3gk7ma5f2qa6uc@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 26, 2019 at 09:32:06AM +0300, Jarkko Sakkinen wrote:
> On Thu, Aug 22, 2019 at 07:10:09PM -0700, Sean Christopherson wrote:
> > Invoke EADD with the userspace source address instead of first copying
> > the data to a kernel page to avoid the overhead of alloc_page() and
> > copy_from_user().
> > 
> > Remove all pre-validation of TCS pages.  The source page is no longer
> > readily available since it's not copied into the kernel, and validating
> > the TCS essentially requires accessing the entire page since the vast
> > majority of the TCS is reserved bytes.  Given that userspace can now
> > cause EADD to fault simply by passing a bad pointer, validating the TCS
> > to avoid faults on EADD provides little to no value.
> > 
> > Suggested-by: Andy Lutomirski <luto@kernel.org>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> I already merged this to my tree but just realized that the commit
> message does not address why get_user_pages() is no option.

AFAICT, gup() would also work, but I don't think it gains us anything,
e.g. validating the TCS still doesn't work because nothing prevents
userspace from scribbling the TCS page after it's checked by the kernel.
If we run into a scenario where we need to check the TCS, e.g. to prevent
using a feature the kernel doesn't support, then we'd have no choice but
to copy it into kernel memory[*].

Going with gup() would be a little more code, and maybe an imperceptibly
small performance hit, but otherwise the two options are more or less the
same.

I (obviously) have a slight preference for passing the userspace address
directly to EADD, but I'm ok with either approach unless the gup code ends
up being particularly ugly.

[*] While typing this out I realized we *must* copy the SECS into kernel
    memory for ECREATE, otherwise the kernel would be susceptible to
    TOCTOU attacks on the allowed attributes.  Probably worth a comment.
