Return-Path: <SRS0=C5Ay=3X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BB6C35247
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Feb 2020 20:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D14C20CC7
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Feb 2020 20:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgBCUEm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Feb 2020 15:04:42 -0500
Received: from mga12.intel.com ([192.55.52.136]:59745 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgBCUEm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Feb 2020 15:04:42 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 12:04:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="234822296"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 03 Feb 2020 12:04:41 -0800
Date:   Mon, 3 Feb 2020 12:04:41 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v25 0/3] x86/sgx: Fix feature control rebase
Message-ID: <20200203200441.GD19638@linux.intel.com>
References: <20200201174940.20984-1-sean.j.christopherson@intel.com>
 <20200201193559.GA7791@linux.intel.com>
 <20200201221804.GA4603@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201221804.GA4603@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Feb 02, 2020 at 12:18:04AM +0200, Jarkko Sakkinen wrote:
> On Sat, Feb 01, 2020 at 09:35:59PM +0200, Jarkko Sakkinen wrote:
> > If you fix any regression, use solely this tag as the baseline for
> > fixes. I worry about possible merge conflicts with the master.
> > 
> > /Jarkko
> 
> As far as I'm concerned master has now everything for v25, so I removed
> the tag. Just test against master.

Sent a fix for the boot issue.

Can you also rebase to Linus' latest tree?  Or any tree that containts
commit 8df5bb4a03b0 ("char: hpet: Fix out-of-bounds read bug").  Spent the
morning bisecting another boot crash due to the hpet bug...
