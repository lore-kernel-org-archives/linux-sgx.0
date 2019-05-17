Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D78C04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 17:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66851216C4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 17:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfEQR34 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 13:29:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:29922 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfEQR34 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 17 May 2019 13:29:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 10:29:55 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga005.fm.intel.com with ESMTP; 17 May 2019 10:29:54 -0700
Date:   Fri, 17 May 2019 10:29:53 -0700
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
Message-ID: <20190517172953.GC15006@linux.intel.com>
References: <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org>
 <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
 <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
 <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 17, 2019 at 12:37:40PM -0400, Stephen Smalley wrote:
> On 5/17/19 12:20 PM, Stephen Smalley wrote:
> >On 5/17/19 11:09 AM, Sean Christopherson wrote:
> >>I think we may want to change the SGX API to alloc an anon inode for each
> >>enclave instead of hanging every enclave off of the /dev/sgx/enclave
> >>inode.
> >>Because /dev/sgx/enclave is NOT private, SELinux's file_map_prot_check()
> >>will only require FILE__WRITE and FILE__EXECUTE to mprotect() enclave
> >>VMAs
> >>to RWX.  Backing each enclave with an anon inode will make SELinux treat
> >>EPC memory like anonymous mappings, which is what we want (I think), e.g.
> >>making *any* EPC page executable will require PROCESS__EXECMEM (SGX is
> >>64-bit only at this point, so SELinux will always have default_noexec).
> >
> >I don't think we want to require EXECMEM (or equivalently both FILE__WRITE
> >and FILE__EXECUTE to /dev/sgx/enclave) for making any EPC page executable,
> >only if the page is also writable or previously modified.  The intent is
> >to prevent arbitrary code execution without EXECMEM (or
> >FILE__WRITE|FILE__EXECUTE), while still allowing enclaves to be created
> >without EXECMEM as long as the EPC page mapping is only ever mapped RX and
> >its initial contents came from an unmodified file mapping that was
> >PROT_EXEC (and hence already checked via FILE__EXECUTE).

The idea is that by providing an SGX ioctl() to propagate VMA permissions
from a source VMA, EXECMEM wouldn't be required to make an EPC page
executable.  E.g. userspace establishes an enclave in non-EPC memory from
an unmodified file (with FILE__EXECUTE perms), and the uses the SGX ioctl()
to copy the contents and permissions into EPC memory.

> Also, just to be clear, there is nothing inherently better about checking
> EXECMEM instead of checking both FILE__WRITE and FILE__EXECUTE to the
> /dev/sgx/enclave inode, so I wouldn't switch to using anon inodes for that
> reason.  Using anon inodes also unfortunately disables SELinux inode-based
> checking since we no longer have any useful inode information, so you'd lose
> out on SELinux ioctl whitelisting on those enclave inodes if that matters.

The problem is that all enclaves are associated with a single inode, i.e.
/dev/sgx/enclave.  /dev/sgx/enclave is a char device whose purpose is to
provide ioctls() and to allow mmap()'ing EPC memory.  In no way is it
associated with the content that actually gets loaded into EPC memory.

The actual file that contains the enclave's contents (assuming the enclave
came from a file) is a separate regular file that the SGX subsystem never
sees.

AIUI, having FILE__WRITE and FILE__EXECUTE on /dev/sgx/enclave would allow
*any* enclave/process to map EPC as RWX.  Moving to anon inodes and thus
PROCESS__EXECMEM achieves per-process granularity.
