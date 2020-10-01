Return-Path: <SRS0=F+z5=DI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D587FC4727E
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 16:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F5C22075F
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 16:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732507AbgJAQwE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Oct 2020 12:52:04 -0400
Received: from mga17.intel.com ([192.55.52.151]:19980 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732016AbgJAQwE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Oct 2020 12:52:04 -0400
IronPort-SDR: PQC+TsAA+HHbwyDXNSn5Do+gO+pvwIFdALxNIFYbFFpqV2R7qDux6Y4TWjL8gHTB/xHv7auKOZ
 EB8W/gR3FDTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="142784799"
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="142784799"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 09:51:53 -0700
IronPort-SDR: vnZjwnEBsaNrEHNt6FL6oX7KB+gFgegXm9v/pi+DG8BukIgPwz9owuBxxwj3lxYh9EIkkueDXF
 q0ZVnutnB45w==
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="346148681"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 09:51:52 -0700
Date:   Thu, 1 Oct 2020 09:51:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
Subject: Re: [PATCH] x86/vdso: Flatten and clean up struct sgx_enclave_run
Message-ID: <20201001165151.GE7474@linux.intel.com>
References: <20201001161642.10500-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001161642.10500-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Can you split this into a proper series?  There are many different things
going on here, reviewing everything at once is difficult.

On Thu, Oct 01, 2020 at 07:16:42PM +0300, Jarkko Sakkinen wrote:
> Reduce the struct size to 64 bytes. It makes sense to have a naturally
> aligning struct size and it leaves 24 bytes of spare space for possible
> future expansion. Having 256 bytes is over the top without any reasonable
> explanation, which does not exist in the commit for the SGX vDSO.

I'm all for dropping the padding, but we should drop reserved fields
altogether and instead reserve space for future features by keeping 'flags',
enforcing it to be zero, and conditioning consumption of future fields on
opt-in flags being set.
 
> Drop struct sgx_exception. It does not serve any semantic purpose in the
> context of this vDSO. Doing this is also consistent with user_handler and

IMO it does serve a purpose, it helps convey that it's a package deal, i.e.
either all fields are valid or none are valid.

> user_data fields, as neither are they encapsulated in an embedded data
> structure.
> 
> Drop 'flags' from sgx_enclave_run as it is an unused value.'vsgx.S'
> literally states this in an inline comment.

It's not unused, it's reserved to zero.

> Pick more reasonable names for the four fields of the exception. For
> example, 'trapnr' should rather be just 'number' because in practice we
> deliver only trap and the rest are faults.

No, in Intel terminology both faults and traps are delivered.  E.g. #DBs
are traps (except for code breakpoints and INT1), #PF and #GP are faults.

That being said, I'm all for changing the 'trapnr' name.  I grabbed it from
from the kernel's exception fixup, it wasn't deliberately chosen to imply
that only trap-like exceptions are reported to userspace.

> Also 'vector' would be an
> adequate name for this field. Document the fields properly in order to
> better explain the values that they have inherited.

My vote is for 'vector'.

> Remove 'exit_reason' as it is really a redundant field to save some space.
> Instead, have just a field called 'leaf' that tells the last seen ENCLU.

This justification contradicts the removal of flags.  If you want to shave
bytes, keep flags and enforce that flags is zero so that you don't need to
have reserved bytes at the end of the struct.

IMO, having a separate exit reason provides saner code for userspace, e.g. 

  if (run->exit_reason == SGX_EXCEPTION_EXIT)
	<do exception stuff>

versus

  if (run->leaf == EENTER || run->leaf == ERESUME)
        <do exception stuff>

I would prefer to be explicit about why the vDSO is transferring control to
the caller or its handler.  It also gives us line of sight to supporting
exit types other than EEXIT and exceptions.  Maybe we never end up with
another type, but IMO shaving 4 bytes and a MOV isn't worth the risk of
ending up with a mess of an API if another exit reason comes along.

> The documentation, selftest and the kernel source code use the terms "user
> handler" and "exit handler" in somewhat inconsistent manner. Start using
> "AEX handler" consistently as this is the term that Intel SDM volume D uses
> for these events.

No, AEX is specifically for "asynchronus" exits.  In this context, that is
limited to the exception path.  The vDSO invokes the user handler for EEXIT,
i.e. the synchrous path, which is not an AEX.
