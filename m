Return-Path: <SRS0=RGqr=3Y=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596FCC3524A
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Feb 2020 05:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 343B92086A
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Feb 2020 05:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgBDF0Z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Feb 2020 00:26:25 -0500
Received: from mga17.intel.com ([192.55.52.151]:7396 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgBDF0Z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Feb 2020 00:26:25 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 21:26:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="224184022"
Received: from ncouniha-mobl6.ger.corp.intel.com (HELO localhost) ([10.252.20.163])
  by orsmga008.jf.intel.com with ESMTP; 03 Feb 2020 21:26:22 -0800
Date:   Tue, 4 Feb 2020 07:26:16 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v25 0/3] x86/sgx: Fix feature control rebase
Message-ID: <20200204052616.GA14225@linux.intel.com>
References: <20200201174940.20984-1-sean.j.christopherson@intel.com>
 <20200201193559.GA7791@linux.intel.com>
 <20200201221804.GA4603@linux.intel.com>
 <20200203200441.GD19638@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203200441.GD19638@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Feb 03, 2020 at 12:04:41PM -0800, Sean Christopherson wrote:
> On Sun, Feb 02, 2020 at 12:18:04AM +0200, Jarkko Sakkinen wrote:
> > On Sat, Feb 01, 2020 at 09:35:59PM +0200, Jarkko Sakkinen wrote:
> > > If you fix any regression, use solely this tag as the baseline for
> > > fixes. I worry about possible merge conflicts with the master.
> > > 
> > > /Jarkko
> > 
> > As far as I'm concerned master has now everything for v25, so I removed
> > the tag. Just test against master.
> 
> Sent a fix for the boot issue.
> 
> Can you also rebase to Linus' latest tree?  Or any tree that containts
> commit 8df5bb4a03b0 ("char: hpet: Fix out-of-bounds read bug").  Spent the
> morning bisecting another boot crash due to the hpet bug...

OK, I'll send the patch set today.

/Jarkko
