Return-Path: <SRS0=qw+Y=UF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2747C04AB5
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 15:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B531220657
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 15:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbfFFPrY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Jun 2019 11:47:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:28791 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729185AbfFFPrY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 6 Jun 2019 11:47:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 08:47:23 -0700
X-ExtLoop1: 1
Received: from harend-mobl.ger.corp.intel.com (HELO localhost) ([10.252.33.8])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2019 08:47:21 -0700
Date:   Thu, 6 Jun 2019 18:47:20 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH 4/7] x86/sgx: Allow userspace to add multiple pages in
 single ioctl()
Message-ID: <20190606154620.GD25112@linux.intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605194845.926-5-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 05, 2019 at 12:48:42PM -0700, Sean Christopherson wrote:
> ...to improve performance when building enclaves by reducing the number
> of user<->system transitions.  Rather than provide arbitrary batching,
> e.g. with per-page SECINFO and mrmask, take advantage of the fact that
> any sane enclave will have large swaths of pages with identical
> properties, e.g. code vs. data sections.
> 
> For simplicity and stability in the initial implementation, loop over
> the existing add page flow instead of taking a more agressive approach,
> which would require tracking transitions between VMAs and holding
> mmap_sem for an extended duration.
> 
> On an error, update the userspace struct to reflect progress made, e.g.
> so that the ioctl can be re-invoked to finish adding pages after a non-
> fatal error.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Probably not going to look at this before other things are settled.

/Jarkko
