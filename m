Return-Path: <SRS0=/STu=5G=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548EBC4332B
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Mar 2020 00:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DF2720A8B
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Mar 2020 00:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgCUA5F (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Mar 2020 20:57:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:57014 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUA5F (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Mar 2020 20:57:05 -0400
IronPort-SDR: 6jVs1Ys75baoIo5OGChp+YXz8GHsMnWla1wl7Qo+xAg30vmdhCLJbPp8aZhMg5LVdm2U1Ou+mK
 dqWVjA+ygYAA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 17:57:04 -0700
IronPort-SDR: mkoZ7CmJ216YT+KeRROomEZgRHGJMZ2FsaGpJfJurYl4FI5gbut3Nojro895HRLHlFMr/cCWS7
 wVfABW0JQrGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="238912321"
Received: from ydubov-mobl1.ger.corp.intel.com (HELO localhost) ([10.254.147.149])
  by fmsmga008.fm.intel.com with ESMTP; 20 Mar 2020 17:57:01 -0700
Date:   Sat, 21 Mar 2020 02:57:00 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 3/8] x86/sgx: vdso: Make
 __vdso_sgx_enter_enclave() callable from C code
Message-ID: <20200321005700.GB7166@linux.intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
 <20200319011130.8556-4-sean.j.christopherson@intel.com>
 <9a4878b9-bcad-b279-acd5-2eef03b13af8@intel.com>
 <20200319201144.GF11305@linux.intel.com>
 <20200320030700.GF183331@linux.intel.com>
 <20200320232649.GG3866@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320232649.GG3866@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 20, 2020 at 04:26:49PM -0700, Sean Christopherson wrote:
> On Fri, Mar 20, 2020 at 05:07:00AM +0200, Jarkko Sakkinen wrote:
> > On Thu, Mar 19, 2020 at 01:11:45PM -0700, Sean Christopherson wrote:
> > > On Thu, Mar 19, 2020 at 01:03:41PM -0700, Xing, Cedric wrote:
> > > > On 3/18/2020 6:11 PM, Sean Christopherson wrote:
> > > > >  #endif
> > > > >  SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > > > >  	/* Prolog */
> > > > >@@ -82,7 +84,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > > > >  	.cfi_rel_offset		%rbp, 0
> > > > >  	mov	%rsp, %rbp
> > > > >  	.cfi_def_cfa_register	%rbp
> > > > >+	push	%rbx
> > > > A CFI directive is needed here:
> > > > 
> > > > 	.cfi_rel_offset 	%rbx, -8
> > > 
> > > Darn, I suspected as much, but wasn't 100% positive.  Shouldn't have
> > > hedged.  :-)
> > > 
> > > Is the rule of thumb for adding directives that one is needed any time
> > > there is a new saved value of a register, or if the relative address of
> > > the last saved value changes?  Are CFI directives only used for
> > > non-volatile registers?
> > 
> > AFAIK the convention is just that if you push a register you need to
> > offset it so that the FDE that is put into .eh_frame by GCC has the
> > information from which locations of the stack the register values are
> > copied.
> > 
> > BTW, why use GCC-style ".L-mangled" label names instead of having more
> > readable ones?
> 
> Readable as in dropping the .L part?  E.g.
> 
>   enclu_eenter_eresume:
> 
> I assumed we'd want to keep the local labels out of the symbols file, but
> maybe getting them in there would be a good thing?

Right, that was the legit reason. Nope, lets keep them then.

/Jarkko
