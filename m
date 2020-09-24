Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37302C4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 20:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0794B20738
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 20:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgIXUZx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 16:25:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:59764 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXUZx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 16:25:53 -0400
IronPort-SDR: EqBQGPka+f3wO8DyTRCaLlSFD1nsdx9nZrPsJz+J/Oe1G1JDc0cjg28igYST7pcDs3b39w2ClK
 xBWVCRaYeZ5w==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="161409135"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="161409135"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 13:25:52 -0700
IronPort-SDR: cEm40dcYnlObO0TbPOblQloHkdQY55tEX3b3EuhYzhlIEueAcQGhPQ4gqn8xl9XRn5lXJhw10A
 efnawiUJQtWQ==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="310512878"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 13:25:52 -0700
Date:   Thu, 24 Sep 2020 13:25:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200924202549.GB19127@linux.intel.com>
References: <20200921211849.GA25403@linux.intel.com>
 <20200922052957.GA97272@linux.intel.com>
 <20200922053515.GA97687@linux.intel.com>
 <20200922164301.GB30874@linux.intel.com>
 <20200923135056.GD5160@linux.intel.com>
 <op.0rgp5h0hwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200924192853.GA18826@linux.intel.com>
 <c680f7bd-2d82-6477-707f-cd03aae4b4aa@intel.com>
 <20200924200156.GA19127@linux.intel.com>
 <e4bcb25f-581a-da93-502b-b8f73e28286a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4bcb25f-581a-da93-502b-b8f73e28286a@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 01:10:31PM -0700, Dave Hansen wrote:
> On 9/24/20 1:01 PM, Sean Christopherson wrote:
> >> In pseudo-C, it's something logically like this for the "nice" case:
> >>
> >> 	ptr = mmap("/some/executable", PROT_EXEC);
> >> 	ioctl(sgx_fd, ADD_ENCLAVE_PAGE, SGX_PROT_EXEC, ptr, size);
> >> 	mmap(sgx_fd);
> >> 	EENTER;
> >>
> >> And we're trying to thwart:
> >>
> >> 	ptr = mmap("/mnt/noexec/file", PROT_READ);
> >> 	ioctl(sgx_fd, ADD_ENCLAVE_PAGE, SGX_PROT_EXEC, ptr, size);
> >> 	mmap(sgx_fd);
> >> 	EENTER;
> >>
> >> because that loads data into the enclave which is executable but which
> >> was not executable normally.  But, we're allowing this from anonymous
> >> memory, so this would seem to work:
> >>
> >> 	ptr = mmap("/mnt/noexec/file", PROT_READ);
> >> 	buffer = malloc(PAGE_SIZE);
> >> 	memcpy(buffer, ptr, PAGE_SIZE);
> >> 	// need mprotect(buf, PROT_EXEC)???
> >> 	ioctl(sgx_fd, ADD_ENCLAVE_PAGE, SGX_PROT_EXEC, buffer, size);
> >> 	mmap(sgx_fd);
> >> 	EENTER;
> >>
> >> and give the same result.  What am I missing?
> > The last example, where the enclave is copied to a buffer, is out of scope
> > for noexec.  But, it is in scope for LSMs, e.g. for this last example, we
> > could add an LSM upcall so that SELinux could require PROCESS_EXECMEM (or an
> > SGX specific equivalent).
> 
> Why don't we just declare enclave memory as "out of scope for noexec" in
> the same way that anonymous memory is, and just discard this patch?
> That doesn't seem too much of a stretch.

Because we lose line of sight to LSM support.  Without enforcing "declare perms
at load time" in the initial series, we would create an ABI where userspace
could load an enclave page with only READ permissions and then map the enclave
with whatever permissions it wants, without any convenient way for SGX to call
into the LSM.

Retroactively enforcing permissions at load time would break the ABI, or at
least yield different behavior based on the mere existence of LSMs, e.g. if
LSMs are supported, suddenly the ADD_PAGES w/ READ -> mmap(RWX) flow breaks,
even if there is no LSM policy denying that behavior.

Enforcing LSM policies using the existing mmap()/mprotect() hooks doesn't work
well because the only information available is a fd pointing at
/dev/sgx/enclave, which is largely useless because /dev/sgx/enclave must be
map SHARED w/ RWX to run an enclave.  We explored things like grabbing a
reference to the source file for later verification, but that means pinning
files for the entire lifetime of an enclave.

Enforcing noexec was an easy/obvious addition since we need 99% of the code for
potential LSM support anyways.
