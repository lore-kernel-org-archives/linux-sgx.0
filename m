Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FE8C4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 22:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98165208E4
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 22:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgIXWHc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 18:07:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:4453 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgIXWHc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 18:07:32 -0400
IronPort-SDR: QBujC1q9tLgGcmMOXqkojIH1d2SY/W/Nt/Ug9J695tOHPjqMr22KtqV1tOoo7DM9g9hJJQv/fl
 aIDYRGf5SA7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="158747644"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="158747644"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 15:07:31 -0700
IronPort-SDR: QJwZR0Nm4vfxw/6m+Na3H+P/Txy3Pb6QGCM1+l9cNF0xHfTla8oRrqEMspV3Li5tLs0mufdpSs
 elkBzcAbsiTg==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="487143228"
Received: from yshmidtx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.63.233])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 15:07:24 -0700
Date:   Fri, 25 Sep 2020 01:07:22 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
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
Message-ID: <20200924220722.GE119995@linux.intel.com>
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
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
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

I did that already for v39. It unconditionally discards noexec
partitions.

I see EMODPE as the key driver for this patch, not noexec partitions.

I.e. post you've done SGX_IOC_ENCLAVE_INIT you are capped when it
comes to permissions.

/Jarkko
