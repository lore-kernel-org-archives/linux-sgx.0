Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F921C04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 19:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08E6D216FD
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 19:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbfEQT2Y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 15:28:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:28707 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbfEQT2Y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 17 May 2019 15:28:24 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 12:28:22 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 17 May 2019 12:28:23 -0700
Date:   Fri, 17 May 2019 12:28:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        "Xing, Cedric" <cedric.xing@intel.com>,
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
Message-ID: <20190517192823.GG15006@linux.intel.com>
References: <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
 <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
 <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
 <837CE33B-A636-4BF8-B46E-0A8A40C5A563@amacapital.net>
 <6d083885-1880-f33d-a54f-23518d56b714@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d083885-1880-f33d-a54f-23518d56b714@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 17, 2019 at 02:05:39PM -0400, Stephen Smalley wrote:
> On 5/17/19 1:12 PM, Andy Lutomirski wrote:
> >
> >How can that work?  Unless the API changes fairly radically, users
> >fundamentally need to both write and execute the enclave.  Some of it will
> >be written only from already executable pages, and some privilege should be
> >needed to execute any enclave page that was not loaded like this.
> 
> I'm not sure what the API is. Let's say they do something like this:
> 
> fd = open("/dev/sgx/enclave", O_RDONLY);
> addr = mmap(NULL, size, PROT_READ | PROT_EXEC, MAP_SHARED, fd, 0);
> stuff addr into ioctl args
> ioctl(fd, ENCLAVE_CREATE, &ioctlargs);
> ioctl(fd, ENCLAVE_ADD_PAGE, &ioctlargs);
> ioctl(fd, ENCLAVE_INIT, &ioctlargs);

That's rougly the flow, except that that all enclaves need to have RW and
X EPC pages.

> The important points are that they do not open /dev/sgx/enclave with write
> access (otherwise they will trigger FILE__WRITE at open time, and later
> encounter FILE__EXECUTE as well during mmap, thereby requiring both to be
> allowed to /dev/sgx/enclave), and that they do not request PROT_WRITE to the
> resulting mapping (otherwise they will trigger FILE__WRITE at mmap time).
> Then only FILE__READ and FILE__EXECUTE are required to /dev/sgx/enclave in
> policy.
> 
> If they switch to an anon inode, then any mmap PROT_EXEC of the opened file
> will trigger an EXECMEM check, at least as currently implemented, as we have
> no useful backing inode information.

Yep, and that's by design in the overall proposal.  The trick is that
ENCLAVE_ADD takes a source VMA and copies the contents *and* the
permissions from the source VMA.  The source VMA points at regular memory
that was mapped and populated using existing mechanisms for loading DSOs.

E.g. at a high level:

source_fd = open("/home/sean/path/to/my/enclave", O_RDONLY);
for_each_chunk {
        <hand waving - mmap()/mprotect() the enclave file into regular memory>
}

enclave_fd = open("/dev/sgx/enclave", O_RDWR); /* allocs anon inode */
enclave_addr = mmap(NULL, size, PROT_READ, MAP_SHARED, enclave_fd, 0);

ioctl(enclave_fd, ENCLAVE_CREATE, {enclave_addr});
for_each_chunk {
        struct sgx_enclave_add ioctlargs = {
                .offset = chunk.offset,
                .source = chunk.addr,
                .size   = chunk.size,
                .type   = chunk.type, /* SGX specific metadata */
        }
        ioctl(fd, ENCLAVE_ADD, &ioctlargs); /* modifies enclave's VMAs */
}
ioctl(fd, ENCLAVE_INIT, ...);


Userspace never explicitly requests PROT_EXEC on enclave_fd, but SGX also
ensures userspace isn't bypassing LSM policies by virtue of copying the
permissions for EPC VMAs from regular VMAs that have already gone through
LSM checks.
