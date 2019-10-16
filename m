Return-Path: <SRS0=tCn0=YJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4B5FA3728
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 22:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38A9921848
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 22:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733203AbfJPWx6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 18:53:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:23813 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbfJPWx6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 18:53:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 15:53:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,305,1566889200"; 
   d="scan'208";a="220935137"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2019 15:53:57 -0700
Date:   Wed, 16 Oct 2019 15:53:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 16/16] x86/vdso: sgx: Rework
 __vdso_sgx_enter_enclave() to prefer "no callback"
Message-ID: <20191016225357.GB8711@linux.intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
 <20191008044613.12350-17-sean.j.christopherson@intel.com>
 <15c03e7e-cd98-5ea2-82a1-a11bec4abe2a@intel.com>
 <20191009191003.GD19952@linux.intel.com>
 <ff6afbe4-1fa9-a632-b5bf-2cdadbb50f37@intel.com>
 <20191010235931.GI23798@linux.intel.com>
 <96a8533b-cbcb-1701-393a-a94552ff717f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96a8533b-cbcb-1701-393a-a94552ff717f@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 16, 2019 at 03:18:05PM -0700, Xing, Cedric wrote:
> On 10/10/2019 4:59 PM, Sean Christopherson wrote:
> >On Thu, Oct 10, 2019 at 10:49:59AM -0700, Xing, Cedric wrote:
> >>On 10/9/2019 12:10 PM, Sean Christopherson wrote:
> >>>On Wed, Oct 09, 2019 at 11:00:55AM -0700, Xing, Cedric wrote:
> >>>>On 10/7/2019 9:46 PM, Sean Christopherson wrote:
> >>>>>-	/* Align stack per x86_64 ABI. The original %rsp is saved in %rbx to be
> >>>>>-	 * restored after the exit handler returns. */
> >>>>>+
> >>>>>+	/* Invoke userspace's exit handler if one was provided. */
> >>>>>+.Lhandle_exit:
> >>>>>+	cmp	$0, 0x20(%rbp)
> >>>>>+	jne	.Linvoke_userspace_handler
> >>>>>+
> >>>>>+.Lout:
> >>>>>+	leave
> >>>>>+	.cfi_def_cfa		%rsp, 8
> >>>>>+	ret
> >>>>>+
> >>>>>+.Linvalid_leaf:
> >>>>
> >>>>Please set frame pointer back to %rbp here, or stack unwinding will fail.
> >>>
> >>>Sorry, coffee isn't doing it's job, what's getting crushed, and where?
> >>
> >>The frame pointer was %rbp but you changed it to %rsp 3 lines ago. That's
> >>correct after "leave" and execution won't pass "ret". But the unwinder
> >>doesn't know. So you have to restore frame pointer after "ret", by
> >>	.cfi_def_cfa		%rbp, 16
> >
> >Isn't the proper fix to move ".cfi_endproc" here?  Which I incorrectly
> >left after the RET for the retpoline.
> 
> No. .cfi_endproc is used by the unwinder to determine if an address falls
> within a function. Its location has nothing to do with where RET is but
> shall always be at the end of the whole function.
> 
> .cfi_def_cfa tells the unwinder where the call frame starts. At here, the
> call frame starts at %rbp+16 but not %rsp+8, so ".cfi_def_cfa %rbp, 16" is a
> must.

Ahh, I understand now, hopefully.  I was thinking the .cfi directives
would magically understand the control flow.  Thanks!

> >>>>>+.Lhandle_exception:
> >>>>>+	mov	0x18(%rbp), %rcx
> >>>>>+	test    %rcx, %rcx
> >>>>>+	je	.Lskip_exception_info
> >>>>
