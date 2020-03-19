Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78FA3C4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 20:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D9AC2071C
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 20:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgCSULq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 16:11:46 -0400
Received: from mga12.intel.com ([192.55.52.136]:33254 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbgCSULq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 16:11:46 -0400
IronPort-SDR: HA9KiGqm3g9RlcekAkJ/2quDWBDn4ZMjsDAX5sOFXZLa4Wc4lCn4uwwa1+/3hCsj5b4f9l38cw
 uZG7JBQJPjiQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 13:11:45 -0700
IronPort-SDR: kPL8kUa2wkI6eStnVd32xIFmNntaP2/6Lm02laCSTlqWir+0me+GyhVspXICtDJW5/QSBf12Vh
 8/7wQPWgSnyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,572,1574150400"; 
   d="scan'208";a="418472411"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 19 Mar 2020 13:11:45 -0700
Date:   Thu, 19 Mar 2020 13:11:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 3/8] x86/sgx: vdso: Make
 __vdso_sgx_enter_enclave() callable from C code
Message-ID: <20200319201144.GF11305@linux.intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
 <20200319011130.8556-4-sean.j.christopherson@intel.com>
 <9a4878b9-bcad-b279-acd5-2eef03b13af8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a4878b9-bcad-b279-acd5-2eef03b13af8@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 19, 2020 at 01:03:41PM -0700, Xing, Cedric wrote:
> On 3/18/2020 6:11 PM, Sean Christopherson wrote:
> >  #endif
> >  SYM_FUNC_START(__vdso_sgx_enter_enclave)
> >  	/* Prolog */
> >@@ -82,7 +84,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> >  	.cfi_rel_offset		%rbp, 0
> >  	mov	%rsp, %rbp
> >  	.cfi_def_cfa_register	%rbp
> >+	push	%rbx
> A CFI directive is needed here:
> 
> 	.cfi_rel_offset 	%rbx, -8

Darn, I suspected as much, but wasn't 100% positive.  Shouldn't have
hedged.  :-)

Is the rule of thumb for adding directives that one is needed any time
there is a new saved value of a register, or if the relative address of
the last saved value changes?  Are CFI directives only used for
non-volatile registers?

> >+	mov	%ecx, %eax
> >  .Lenter_enclave:
> >  	/* EENTER <= leaf <= ERESUME */
> >  	cmp	$0x2, %eax
> >@@ -108,6 +112,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> >  	jne	.Linvoke_userspace_handler
> >  .Lout:
> >+	pop	%rbx
> >  	leave
> >  	.cfi_def_cfa		%rsp, 8
> >  	ret
> >
