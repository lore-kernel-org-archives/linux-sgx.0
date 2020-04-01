Return-Path: <SRS0=Q2Hp=5R=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265CFC43331
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Apr 2020 00:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7DF220842
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Apr 2020 00:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731480AbgDAAYp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Mar 2020 20:24:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:32227 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729514AbgDAAYp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 31 Mar 2020 20:24:45 -0400
IronPort-SDR: 49OP419IhdcdL106sZJWmBWABWBsfCofdzSvbFeb5p7f95wHOAO+Y0abnQRqfxpvRxtwBPHdWt
 ytg6mYzlqjSg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 17:24:44 -0700
IronPort-SDR: 8pchxnK3OubLwG7i6ISfLlpsfrLENEL1Z/YdONO53+oWXauz7xSx7G34InzCkVmeLWYKgq2ijE
 caHrLSfCHykw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,329,1580803200"; 
   d="scan'208";a="450351490"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 31 Mar 2020 17:24:44 -0700
Date:   Tue, 31 Mar 2020 17:24:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200401002443.GE4847@linux.intel.com>
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
 <20200331114432.7593-3-jarkko.sakkinen@linux.intel.com>
 <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 31, 2020 at 10:39:38AM -0700, Andy Lutomirski wrote:
> On Tue, Mar 31, 2020 at 4:44 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > When creating an enclave attach it to an anonymous file. This prepares the
> > code to have a separate interface at runtime, which can be published to the
> > user space after the enclave has been fully initialized.
> 
> This isn't an objection per se, but I can't shake the feeling that
> this seems ridiculous.  This changes the type of object returned by
> open() because, without this change, the old type was problematic.
> 
> So I have some questions:
> 
>  - Can sgx just ignore the fs noexec option on the chardev inode's fs instead?

Not easily.  do_mmap() rejects PROT_EXEC based on noexec without checking
VM_MAYEXEC (because it's the one that configures VM_MAYEXEC).  SGX could add
VM_MAYEXEC back in during its ->mmap hook, but it would mean userspace would
never be able to do mmap() w/ PROT_EXEC, i.e. would always have to mmap()
then mprotect().  I don't see any way to a dodge the check without doing
something nasty.

                        if (path_noexec(&file->f_path)) {
                                if (vm_flags & VM_EXEC)
                                        return -EPERM;
                                vm_flags &= ~VM_MAYEXEC;
                        }

>  - Would SELinux users *want* to put a useful label on the inode?

Probably?  EXECMEM is likely the biggest point of contention.  I assume
users would also want to do ioctl() whitelisting, etc...  I can't think of
a use case where someone would want to lock down the SGX ioctls, but I can
see someone wanting to ensure the enclave fd can only be used for SGX stuff.

> if so, can they still accomplish whatever they were trying to accomplish
> with this patch applied?

Not at this time.  There's the "secure anon inode" series floating around
that would theoretically remedy that, but that's pure happenstance and not
something we want to rely on.

It wasn't mentioned in the cover letter, but this will effectively require
PROCESS_EXECMEM (in SELinux) for all processes that _run_ enclaves.  It
would allow processes that only _build_ enclaves to avoid PROCESS_EXECMEM,
as they wouldn't need to actually map the enclave.  Jarkko's contention is
enclaves _should_ require EXECMEM and that it's ok to require EXECMEM on
the runtime so long as the builder can run without EXECMEM.

If EXECMEM is a sticking point, one way to dodge it would be to add a
helper to allow SELinux to detect enclave files.  It'd be ugly, but simple.
That doesn't solve the generic labeling issue though.  It also begs the
question of why hacking SELinux but not do_mmap() would be acceptable.

If you have any ideas for fixing the noexec issue without resorting to an
anon inode, we're all ears.

> 
> --Andy
