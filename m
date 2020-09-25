Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9775C4346E
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 00:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78773208A9
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 00:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgIYAA4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 20:00:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:37670 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726662AbgIYAA4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 20:00:56 -0400
IronPort-SDR: zLY5OmMdNpo7wJWsvwtdB3bFt89fcWz5Lx84rqdgmDeorUREzwEnp7YtAdv3nFOjLhg9u1cLSa
 ZDsEK31bUKGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="140813204"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="140813204"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:00:55 -0700
IronPort-SDR: 6XZgjc7WoidoEn2AgUju4NOOoLvncOPZVj/1GN8uJrlzkbEiajq7bH/SnRuf173xFcinsr8GKR
 KJLSYjHSBKjA==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="348036152"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:00:54 -0700
Date:   Thu, 24 Sep 2020 17:00:52 -0700
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
Message-ID: <20200925000052.GA20333@linux.intel.com>
References: <20200923135056.GD5160@linux.intel.com>
 <op.0rgp5h0hwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200924192853.GA18826@linux.intel.com>
 <c680f7bd-2d82-6477-707f-cd03aae4b4aa@intel.com>
 <20200924200156.GA19127@linux.intel.com>
 <e4bcb25f-581a-da93-502b-b8f73e28286a@intel.com>
 <20200924202549.GB19127@linux.intel.com>
 <e25bfeaa-afb4-3928-eb80-50d90815eabb@intel.com>
 <20200924230501.GA20095@linux.intel.com>
 <b737fcab-bfde-90e1-1101-82d646a6f5b7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b737fcab-bfde-90e1-1101-82d646a6f5b7@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 04:09:25PM -0700, Dave Hansen wrote:
> On 9/24/20 4:05 PM, Sean Christopherson wrote:
> > The problem is that enforcing permissions via mprotect() needs to be done
> > unconditionally, otherwise we end up with weird behavior where the existence
> > of an LSM will change what is/isn't allowed, even if the LSM(s) has no SGX
> > policy whatsover.
> 
> Could we make this a bit less abstract, please?
> 
> Could someone point to code or another examples that demonstrates how
> the mere existence of an LSM will change what is/isn't allowed?
> 
> I can't seem to wrap my head around it as-is.

Without pre-declared permissions, loading and running an enclave would be:

	ptr = malloc(size);
        memcpy(ptr, evil_shenanigans, size);
	ioctl(sgx_fd, ENCLAVE_ADD_PAGE, ptr, size);
        ...
	ioctl(sgx_fd, ENCLAVE_INIT);

        enclave = mmap(sgx_fd, ... PROT_READ);
        mprotect(enclave, ..., PROT_READ | PROT_EXEC);

	EENTER;

With the existing security_file_mprotect(), an LSM will see:

        vma->vm_file ~= /dev/sgx/enclave
        prot = PROT_READ | PROT_EXEC

From a policy perspective, the LSM can't do much because every enclave is
backed by /dev/sgx/enclave, and all enclaves need READ and EXEC perms, i.e.
a policy can only deny all enclaves or allow enclaves.

The solution we came up with is to require userspace to declare the intended
permissions at build time so that an LSM hook can be invoked when the source
VMA is availble, e.g. in this example, the LSM would see that the process is
loading executable code into an enclave from an anonymous VMA:

        ptr = malloc(size);
        memcpy(ptr, evil_shenanigans, size);
	ioctl(sgx_fd, ENCLAVE_ADD_PAGE, SGX_PROT_READ | SGX_PROT_EXEC, ptr, size);
        {
                ret = security_enclave_load(ptr, prot);
                if (ret)
                        return ret;

                enclave_page->declared_prot = prot;
        }
        ...
	ioctl(sgx_fd, ENCLAVE_INIT);

and then enforce the declared perms via ->mprotect()

        enclave = mmap(sgx_fd, ... PROT_READ);
        mprotect(enclave, ..., PROT_READ | PROT_EXEC);
        |
        -> sgx_mprotect(...)
           {
                   if (~enclave_page->declared_prot & prot)
                        return -EACCES;
           }

	EENTER;

So the above would be allowed, but this would fail (irrespective of LSM behavior):

        ptr = malloc(size);
        memcpy(ptr, evil_shenanigans, size);
	ioctl(sgx_fd, ENCLAVE_ADD_PAGE, SGX_PROT_READ, ptr, size);
        ...
	ioctl(sgx_fd, ENCLAVE_INIT);

        enclave = mmap(sgx_fd, ... PROT_READ);
        mprotect(enclave, ..., PROT_READ | PROT_EXEC);


My concern is that if we merge this

        ioctl(sgx_fd, ENCLAVE_ADD_PAGE, SGX_PROT_READ | SGX_PROT_EXEC, ptr, size);

without ->mprotect(), we can't actually enforce the declared protections.  And
if we drop the field altogether:

        ioctl(sgx_fd, ENCLAVE_ADD_PAGE, ptr, size);

then we can't implement security_enclave_load().
