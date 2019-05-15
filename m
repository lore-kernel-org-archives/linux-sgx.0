Return-Path: <SRS0=97/O=TP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B111C04AA7
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 05:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03D962084E
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 05:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbfEOFPW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 May 2019 01:15:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:30884 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbfEOFPW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 15 May 2019 01:15:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 22:15:20 -0700
X-ExtLoop1: 1
Received: from hhuan26-mobl.amr.corp.intel.com ([10.255.33.85])
  by fmsmga004.fm.intel.com with ESMTP; 14 May 2019 22:15:18 -0700
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To:     "Andy Lutomirski" <luto@kernel.org>,
        "Xing, Cedric" <cedric.xing@intel.com>
Cc:     "Jethro Beekman" <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "X86 ML" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "Borislav Petkov" <bp@alien8.de>,
        "Josh Triplett" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Reply-To: haitao.huang@linux.intel.com
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
 <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com>
 <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com>
 <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
 <CALCETrV7CcDnx1hVtmBnDNABG11GuMqyspJMMpV+zHpVeFu3ow@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E885F9D@ORSMSX116.amr.corp.intel.com>
 <979615a8-fd03-e3fd-fbdb-65c1e51afd93@fortanix.com>
 <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
 <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <op.z1saqpzxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <CALCETrXHbRL-pzZ7CG+RrMNGNEPKO9LY=6Bo4tuFzcZ_ZTMQvQ@mail.gmail.com>
 <op.z1sdc6m4wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <CALCETrVfUfcs8ntj6tAzGo5eiaDGnLvUmgkUXNLX0a6SyJT+pg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E11D8@ORSMSX116.amr.corp.intel.com>
Date:   Wed, 15 May 2019 00:15:17 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.z1tfjrj4wjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654E11D8@ORSMSX116.amr.corp.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 14 May 2019 16:58:24 -0500, Xing, Cedric <cedric.xing@intel.com>  
wrote:

> Hi Everyone,
>
> I think we are talking about 2 different kinds of criteria for  
> determining the sanity of an enclave.
>
> The first kind determines an enclave's sanity by generally accepted good  
> practices. For example, no executable pages shall ever be writable.
>

We'll have to trust user space doing mmap with right permissions as  
SELinux does not enforce which segment to be RW and which to be RX. The  
file needs to have SELinux EXECUTE and WRITE both, if we need map some  
segments with RW and others with RX.

We could say EINIT would ensure user is doing the right thing because it  
would fail if user map permission wrongly. Then the extra mmaps are  
redundant of doing SIGSTRUCT verification.

Additionally, per Sean's comments, after EADD in current implementation,  
we will still need PROCESS_EXECMEM for mprotect on enclave fd to change  
some EPC pages PTE to RX before enclave can execute. So I don't think mmap  
the source enclave file would gain anything in addition to what your  
proposed security_sgx_initialize_enclave() does.


Since security_sgx_initialize_enclave() is a lot like launch control  
policy enforcement we discussed a lot and resolved, I tend to agree with  
Andy's assessment we can just do nothing for the initial merge and add  
hooks needed if someone wants them. And the initial merge would require  
the enclave hosting processes ask for PROCESS_EXECMEM permission to do  
mmap/mprotect with enclave fd.
