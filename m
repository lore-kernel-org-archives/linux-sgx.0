Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AF9C282E1
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 20:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D8542081C
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 20:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391738AbfEXU6g convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 16:58:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:43463 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729974AbfEXU6g (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 24 May 2019 16:58:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 13:58:35 -0700
X-ExtLoop1: 1
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga005.jf.intel.com with ESMTP; 24 May 2019 13:58:34 -0700
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 24 May 2019 13:58:34 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.116]) with mapi id 14.03.0415.000;
 Fri, 24 May 2019 13:58:34 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Andy Lutomirski" <luto@kernel.org>
CC:     Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
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
Subject: RE: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Topic: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Index: AQHVC0vUmIXibKT8TUm/EUnHn2XAfqZu5q2AgAAGWoCABXOKgIABz2SAgAAI9ACAAWgPAIAAAJWAgAAJhACAAByGAIAAdoKAgABA+ICAAIOmAIAAQKcAgAAWeICAAIbLAIAAGyYA///WAeCAARtHgIAAIeCAgAADbAD//5AmcIAAjJAAgAAHN4D//5WNMA==
Date:   Fri, 24 May 2019 20:58:33 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654E8FF2@ORSMSX116.amr.corp.intel.com>
References: <20190523141752.GA12078@linux.intel.com>
 <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
 <20190523234044.GC12078@linux.intel.com>
 <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
 <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov>
 <20190524174243.GA365@linux.intel.com>
 <20190524175458.GB365@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
 <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com>
 <20190524200333.GF365@linux.intel.com>
In-Reply-To: <20190524200333.GF365@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjhhZmZhNzQtMWUxOS00ODk5LWJjM2ItYWQxNGYyYjhkNWNiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTmh4R25MMmZWWHB6OGN0TkdveFNLYytmK05rODN3UjVQNmVERnNLaDQzOVlrNFRhdGt0NUpaUWN5Mzcycmo2RCJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
> owner@vger.kernel.org] On Behalf Of Sean Christopherson
> Sent: Friday, May 24, 2019 1:04 PM
> 
> On Fri, May 24, 2019 at 12:37:44PM -0700, Andy Lutomirski wrote:
> > On Fri, May 24, 2019 at 11:34 AM Xing, Cedric <cedric.xing@intel.com>
> wrote:
> > >
> > > If "initial permissions" for enclaves are less restrictive than
> > > shared objects, then it'd become a backdoor for circumventing LSM
> > > when enclave whitelisting is *not* in place. For example, an
> > > adversary may load a page, which would otherwise never be executable,
> as an executable page in EPC.
> > >
> > > In the case a RWX page is needed, the calling process has to have a
> > > RWX page serving as the source for EADD so PROCESS__EXECMEM will
> > > have been checked. For SGX2, changing an EPC page to RWX is subject
> > > to FILE__EXECMEM on /dev/sgx/enclave, which I see as a security
> > > benefit because it only affects the enclave but not the whole
> process hosting it.
> >
> > So the permission would be like FILE__EXECMOD on the source enclave
> > page, because it would be mapped MAP_ANONYMOUS, PROT_WRITE?
> > MAP_SHARED, PROT_WRITE isn't going to work because that means you can
> > modify the file.
> 
> Was this in response to Cedric's comment, or to my comment?

Creating RWX source page requires PROCESS_EXECMEM. But as I responded to Sean earlier, I think his proposal of "aggregating" all "initial" permission checks into a single SIGSTRUCT check is probably a better approach.

> 
> > I'm starting to think that looking at the source VMA permission bits
> > or source PTE permission bits is putting a bit too much policy into
> > the driver as opposed to the LSM.  How about delegating the whole
> > thing to an LSM hook?  The EADD operation would invoke a new hook,
> > something like:
> >
> > int security_enclave_load_bytes(void *source_addr, struct
> > vm_area_struct *source_vma, loff_t source_offset, unsigned int
> > maxperm);

This is exactly what I was thinking. But with Sean's proposal this is probably no longer necessary.

> >
> > Then you don't have to muck with mapping anything PROT_EXEC.  Instead
> > you load from a mapping of a file and the LSM applies whatever policy
> > it feels appropriate.  If the first pass gets something wrong, the
> > application or library authors can take it up with the SELinux folks
> > without breaking the whole ABI :)
> >
> > (I'm proposing passing in the source_vma because this hook would be
> > called with mmap_sem held for read to avoid a TOCTOU race.)
> >
> > If we go this route, the only substantial change to the existing
> > driver that's needed for an initial upstream merge is the maxperm
> > mechanism and whatever hopefully minimal API changes are needed to
> > allow users to conveniently set up the mappings.  And we don't need to
> > worry about how to hack around mprotect() calling into the LSM,
> > because the LSM will actually be aware of SGX and can just do the
> > right thing.
> 
> This doesn't address restricting which processes can run which enclaves,
> it only allows restricting the build flow.  Or are you suggesting this
> be done in addition to whitelisting sigstructs?

In the context of SELinux, new types could be defined to be associated with SIGSTRUCT (or more precisely, files containing SIGSTRUCTs). Then the LSM hook (I'd propose security_sgx_initialize_enclave) could enforce whatever...

> 
> What's the value prop beyond whitelisting sigstructs?  Realistically, I
> doubt LSMs/users will want to take the performance hit of scanning the
> source bytes every time an enclave is loaded.
> 
> We could add seomthing like security_enclave_mprotect() in lieu of
> abusing security_file_mprotect(), but passing the full source bytes
> seems a bit much.

I'd just use /dev/sgx/enclave to govern "runtime" permissions any EPC page can mmap()/mprotect() to. Then we won't need any code changes in LSM.

-Cedric
