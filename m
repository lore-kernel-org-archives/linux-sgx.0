Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04256C072B5
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 18:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB0DE2175B
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 18:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbfEXSee convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 14:34:34 -0400
Received: from mga04.intel.com ([192.55.52.120]:27663 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727465AbfEXSed (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 24 May 2019 14:34:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 11:34:33 -0700
X-ExtLoop1: 1
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga005.jf.intel.com with ESMTP; 24 May 2019 11:34:33 -0700
Received: from orsmsx121.amr.corp.intel.com (10.22.225.226) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 24 May 2019 11:34:33 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX121.amr.corp.intel.com ([169.254.10.64]) with mapi id 14.03.0415.000;
 Fri, 24 May 2019 11:34:32 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Stephen Smalley" <sds@tycho.nsa.gov>
CC:     Andy Lutomirski <luto@kernel.org>,
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
Thread-Index: AQHVC0vUmIXibKT8TUm/EUnHn2XAfqZu5q2AgAAGWoCABXOKgIABz2SAgAAI9ACAAWgPAIAAAJWAgAAJhACAAByGAIAAdoKAgABA+ICAAIOmAIAAQKcAgAAWeICAAIbLAIAAGyYA///WAeCAARtHgIAAIeCAgAADbAD//5AmcA==
Date:   Fri, 24 May 2019 18:34:32 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
References: <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com>
 <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com>
 <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
 <20190523234044.GC12078@linux.intel.com>
 <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
 <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov>
 <20190524174243.GA365@linux.intel.com> <20190524175458.GB365@linux.intel.com>
In-Reply-To: <20190524175458.GB365@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjM1YjY3NGMtZmM1Mi00ZWM3LTg2MWEtZjQ4MjdjMTI2MTg4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoieEgxQ1NRZkl6MlIyMEN5YzZBT01zQTA2dngxUDA1ajFGcm81R2VLeExWSHZEYnVLRjM3bFErRUtNN0FsbDlMSCJ9
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
> Sent: Friday, May 24, 2019 10:55 AM
> 
> On Fri, May 24, 2019 at 10:42:43AM -0700, Sean Christopherson wrote:
> > Hmm, I've been thinking more about pulling permissions from the source
> > page.  Conceptually I'm not sure we need to meet the same requirements
> as
> > non-enclave DSOs while the enclave is being built, i.e. do we really
> need
> > to force userspace to fully map the enclave in normal memory?
> >
> > Consider the Graphene scenario where it's building an enclave on the
> fly.
> > Pulling permissions from the source VMAs means Graphene has to map the
> > code pages of the enclave with X.  This means Graphene will need
> EXEDMOD
> > (or EXECMEM if Graphene isn't careful).  In a non-SGX scenario this
> makes
> > perfect sense since there is no way to verify the end result of RW->RX.
> >
> > But for SGX, assuming enclaves are whitelisted by their sigstruct
> (checked
> > at EINIT) and because page permissions affect sigstruct.MRENCLAVE, it
> *is*
> > possible to verify the resulting RX contents.  E.g. for the purposes
> of
> > LSMs, can't we use the .sigstruct file as a proxy for the enclave and
> > require FILE__EXECUTE on the .sigstruct inode to map/run the enclave?
> >
> > Stephen, is my logic sound?
> >
> >
> > If so...
> >
> >   - Require FILE__READ+FILE__EXECUTE on .sigstruct to mmap() the
> enclave.
> >
> >   - Prevent userspace from mapping the enclave with permissions beyond
> the
> >     original permissions of the enclave.  This can be done by
> populating
> >     VM_MAY{READ,WRITE,EXEC} from the SECINFO (same basic concept as
> Andy's
> >     proposals).  E.g. pre-EINIT, mmap() and mprotect() can only
> succeed
> >     with PROT_NONE.
> >
> >   - Require FILE__{READ,WRITE,EXECUTE} on /dev/sgx/enclave for
> simplicity,
> >     or provide an alternate SGX_IOC_MPROTECT if we want to sidestep
> the
> >     FILE__WRITE requirement.
> 
> One more thought.  EADD (and the equivalent SGX2 flow) could do
> security_mmap_file() with a NULL file on the SECINFO permissions, which
> would trigger PROCESS_EXECMEM if an enclave attempts to map a page RWX.

If "initial permissions" for enclaves are less restrictive than shared objects, then it'd become a backdoor for circumventing LSM when enclave whitelisting is *not* in place. For example, an adversary may load a page, which would otherwise never be executable, as an executable page in EPC.

In the case a RWX page is needed, the calling process has to have a RWX page serving as the source for EADD so PROCESS__EXECMEM will have been checked. For SGX2, changing an EPC page to RWX is subject to FILE__EXECMEM on /dev/sgx/enclave, which I see as a security benefit because it only affects the enclave but not the whole process hosting it.

> 
> > No changes are required to LSMs, SGX1 has a single LSM touchpoint in
> its
> > mmap(), and I *think* the only required userspace change is to mmap()
> > PROT_NONE when allocating the enclave's virtual address range.

I'm not sure I understand the motivation behind this proposal to decouple initial EPC permissions from source pages.

I don't think it a big deal to fully mmap() enclave files, which have to be parsed by user mode anyway to determine various things including but not limited to the size of heap(s), size and number of TCSs/stacks/TLS areas, and the overall enclave size. So with PHDRs parsed, it's trivial to mmap() each segment with permissions from its PHDR.

> >
> > As for Graphene, it doesn't need extra permissions to run its enclaves,
> > it just needs a way to install .sigstruct, which is a generic
> permissions
> > problem and not SGX specific.
> >
> >
> > For SGX2 maybe:
> >
> >   - No additional requirements to map an EAUG'd page as RW page.  Not
> >     aligned with standard MAP_SHARED behavior, but we really don't
> want
> >     to require FILE__WRITE, and thus allow writes to .sigstruct.
> >
> >   - Require FILE__EXECMOD on the .sigstruct to map previously writable
> >     page as executable (which indirectly includes all EAUG'd pages).
> >     Wiring this up will be a little funky, but we again we don't want
> >     to require FILE__WRITE on .sigstruct.
> >

I'm lost. Why is EAUG tied to permissions on .sigstruct? 

-Cedric
