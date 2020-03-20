Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A75C4332B
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 03:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B43152075E
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 03:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgCTDHE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 23:07:04 -0400
Received: from mga17.intel.com ([192.55.52.151]:20281 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbgCTDHE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 23:07:04 -0400
IronPort-SDR: Q6vITU4waxPb+N5N5qgOzK3m47bxREcGhvyjIp32wF/nbbkxJoo1uRC+xzztNHpNAQonHpSVeX
 9txT2ojEF3KQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 20:07:03 -0700
IronPort-SDR: L2Oz9ClVW2h098P8i84L5kQ3RBwFCGG2xrPmorBYCpwAVL4oSo+fDf9Gf04y+Ed3uJX+rq4Z2k
 GkNw+F7G8ajQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="444821358"
Received: from anakash-mobl2.ger.corp.intel.com (HELO localhost) ([10.251.183.74])
  by fmsmga005.fm.intel.com with ESMTP; 19 Mar 2020 20:07:01 -0700
Date:   Fri, 20 Mar 2020 05:07:00 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 3/8] x86/sgx: vdso: Make
 __vdso_sgx_enter_enclave() callable from C code
Message-ID: <20200320030700.GF183331@linux.intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
 <20200319011130.8556-4-sean.j.christopherson@intel.com>
 <9a4878b9-bcad-b279-acd5-2eef03b13af8@intel.com>
 <20200319201144.GF11305@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319201144.GF11305@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 19, 2020 at 01:11:45PM -0700, Sean Christopherson wrote:
> On Thu, Mar 19, 2020 at 01:03:41PM -0700, Xing, Cedric wrote:
> > On 3/18/2020 6:11 PM, Sean Christopherson wrote:
> > >  #endif
> > >  SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > >  	/* Prolog */
> > >@@ -82,7 +84,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > >  	.cfi_rel_offset		%rbp, 0
> > >  	mov	%rsp, %rbp
> > >  	.cfi_def_cfa_register	%rbp
> > >+	push	%rbx
> > A CFI directive is needed here:
> > 
> > 	.cfi_rel_offset 	%rbx, -8
> 
> Darn, I suspected as much, but wasn't 100% positive.  Shouldn't have
> hedged.  :-)
> 
> Is the rule of thumb for adding directives that one is needed any time
> there is a new saved value of a register, or if the relative address of
> the last saved value changes?  Are CFI directives only used for
> non-volatile registers?

AFAIK the convention is just that if you push a register you need to
offset it so that the FDE that is put into .eh_frame by GCC has the
information from which locations of the stack the register values are
copied.

BTW, why use GCC-style ".L-mangled" label names instead of having more
readable ones?

/Jarkko
