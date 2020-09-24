Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9BCC4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 20:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E0F42344C
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 20:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgIXUCF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 16:02:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:51296 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbgIXUCF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 16:02:05 -0400
IronPort-SDR: RhDNDJDch2FiKGu5OrZuuZkZ8LZMR/SX9Xqww9ivDvvvwN0LxFweTgCh00CFAVlHtm323bG/Nt
 38pttPG7oAqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="246136004"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="246136004"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 13:01:58 -0700
IronPort-SDR: xPsthE/BSH1LRuZED06CxuzJbuNC+7hL54fu/LRloHKfq0y4iE/8EwOu9ok9QwRfaer0dI4PlI
 LDTge9KmZvIQ==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="511757770"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 13:01:57 -0700
Date:   Thu, 24 Sep 2020 13:01:56 -0700
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
Message-ID: <20200924200156.GA19127@linux.intel.com>
References: <20200921165758.GA24156@linux.intel.com>
 <20200921210736.GB58176@linux.intel.com>
 <20200921211849.GA25403@linux.intel.com>
 <20200922052957.GA97272@linux.intel.com>
 <20200922053515.GA97687@linux.intel.com>
 <20200922164301.GB30874@linux.intel.com>
 <20200923135056.GD5160@linux.intel.com>
 <op.0rgp5h0hwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200924192853.GA18826@linux.intel.com>
 <c680f7bd-2d82-6477-707f-cd03aae4b4aa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c680f7bd-2d82-6477-707f-cd03aae4b4aa@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 12:39:24PM -0700, Dave Hansen wrote:
> On 9/24/20 12:28 PM, Sean Christopherson wrote:
> > On Thu, Sep 24, 2020 at 02:11:37PM -0500, Haitao Huang wrote:
> >> On Wed, 23 Sep 2020 08:50:56 -0500, Jarkko Sakkinen
> >> <jarkko.sakkinen@linux.intel.com> wrote:
> >>> I'll categorically deny noexec in the next patch set version.
> >>>
> >>> /Jarkko
> >> There are use cases supported currently in which enclave binary is received
> >> via IPC/RPC and held in buffers before EADD. Denying noexec altogether would
> >> break those, right?
> > No.  noexec only applies to file-backed VMAs, what you're describing is loading
> > an enclave from an anon VMA, which will still have VM_MAYEXEC.
> 
> Maybe I'm just stupid, but I still don't get the scenario that's being
> thwarted or why it is valuable.  The SDM is worthless on what EMODPE
> does or what its restrictions are.
> 
> In pseudo-C, it's something logically like this for the "nice" case:
> 
> 	ptr = mmap("/some/executable", PROT_EXEC);
> 	ioctl(sgx_fd, ADD_ENCLAVE_PAGE, SGX_PROT_EXEC, ptr, size);
> 	mmap(sgx_fd);
> 	EENTER;
> 
> And we're trying to thwart:
> 
> 	ptr = mmap("/mnt/noexec/file", PROT_READ);
> 	ioctl(sgx_fd, ADD_ENCLAVE_PAGE, SGX_PROT_EXEC, ptr, size);
> 	mmap(sgx_fd);
> 	EENTER;
> 
> because that loads data into the enclave which is executable but which
> was not executable normally.  But, we're allowing this from anonymous
> memory, so this would seem to work:
> 
> 	ptr = mmap("/mnt/noexec/file", PROT_READ);
> 	buffer = malloc(PAGE_SIZE);
> 	memcpy(buffer, ptr, PAGE_SIZE);
> 	// need mprotect(buf, PROT_EXEC)???
> 	ioctl(sgx_fd, ADD_ENCLAVE_PAGE, SGX_PROT_EXEC, buffer, size);
> 	mmap(sgx_fd);
> 	EENTER;
> 
> and give the same result.  What am I missing?

The last example, where the enclave is copied to a buffer, is out of scope
for noexec.  But, it is in scope for LSMs, e.g. for this last example, we
could add an LSM upcall so that SELinux could require PROCESS_EXECMEM (or an
SGX specific equivalent).

The ->mprotect() hook gives us direct line of sight to such LSM upcalls,
e.g. I have fully working code that implements the LSM integration.  LSM
support isn't in this series because the only thing everyone could agree on
in terms of an LSM implementation is that it wasn't needed for initial
upstreaming :-)
