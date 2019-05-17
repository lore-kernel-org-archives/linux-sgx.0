Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AEAC04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 15:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3EC521726
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 15:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfEQPJu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 11:09:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:20328 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbfEQPJu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 17 May 2019 11:09:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 08:09:49 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 17 May 2019 08:09:48 -0700
Date:   Fri, 17 May 2019 08:09:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190517150948.GA15632@linux.intel.com>
References: <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org>
 <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org>
 <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 17, 2019 at 09:53:06AM -0400, Stephen Smalley wrote:
> On 5/16/19 6:23 PM, Xing, Cedric wrote:
> >I thought EXECMOD applied to files (and memory mappings backed by them) but
> >I was probably wrong. It sounds like EXECMOD applies to the whole process so
> >would allow all pages within a process's address space to be modified then
> >executed, regardless the backing files. Am I correct this time?
> 
> No, you were correct the first time I think; EXECMOD is used to control
> whether a process can make executable a private file mapping that has
> previously been modified (e.g. text relocation); it is a special case to
> support text relocations without having to allow full EXECMEM (i.e. execute
> arbitrary memory).
> 
> SELinux checks relevant to W^X include:
> 
> - EXECMEM: mmap/mprotect PROT_EXEC an anonymous mapping (regardless of
> PROT_WRITE, since we know the content has to have been written at some
> point) or a private file mapping that is also PROT_WRITE.
> - EXECMOD: mprotect PROT_EXEC a private file mapping that has been
> previously modified, typically for text relocations,
> - FILE__WRITE: mmap/mprotect PROT_WRITE a shared file mapping,
> - FILE__EXECUTE: mmap/mprotect PROT_EXEC a file mapping.
> 
> (ignoring EXECSTACK and EXECHEAP here since they aren't really relevant to
> this discussion)
> 
> So if you want to ensure W^X, then you wouldn't allow EXECMEM for the
> process, EXECMOD by the process to any file, and the combination of both
> FILE__WRITE and FILE__EXECUTE by the process to any file.
> 
> If the /dev/sgx/enclave mappings are MAP_SHARED and you aren't using an
> anonymous inode, then I would expect that only the FILE__WRITE and
> FILE__EXECUTE checks are relevant.

Yep, I was just typing this up in a different thread:

I think we may want to change the SGX API to alloc an anon inode for each
enclave instead of hanging every enclave off of the /dev/sgx/enclave inode.
Because /dev/sgx/enclave is NOT private, SELinux's file_map_prot_check()
will only require FILE__WRITE and FILE__EXECUTE to mprotect() enclave VMAs
to RWX.  Backing each enclave with an anon inode will make SELinux treat
EPC memory like anonymous mappings, which is what we want (I think), e.g.
making *any* EPC page executable will require PROCESS__EXECMEM (SGX is
64-bit only at this point, so SELinux will always have default_noexec).
