Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1005C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 20:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67A2921873
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 20:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfCTUiI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 16:38:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:49092 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbfCTUiI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 16:38:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 13:38:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="329104835"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga006.fm.intel.com with ESMTP; 20 Mar 2019 13:38:06 -0700
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 20 Mar 2019 13:38:05 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.78]) by
 ORSMSX123.amr.corp.intel.com ([169.254.1.81]) with mapi id 14.03.0415.000;
 Wed, 20 Mar 2019 13:38:05 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Haitao Huang" <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Topic: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Index: AQHU3zmquZHDGSY4XUWmggeyxtSmi6YU12fwgACBcQD//5sEUA==
Date:   Wed, 20 Mar 2019 20:38:04 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com>
In-Reply-To: <20190320191318.GF30469@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2E4OTNhZDQtZWI2ZS00MDRmLTliMmUtYjU2Mjk4ZmE1YzMzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidW1sdnlmTnpLK3BEeHdIN2FncE4xdURXSVd5STA1U3h6TjFlMlFpd1lnbENoQTB1U2MrMjRCSUdzVlg3a1RBQiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> > By requiring preservation of RSP at both AEX and EEXIT, this precludes
> > the possibility of using the untrusted stack as temporary storage by
> > enclaves. While that looks reasonable at first glance, I'm afraid it
> > isn't the case in reality. The untrusted stack is inarguably the most
> > convenient way for data exchange between an enclave and its enclosing
> > process,
> 
> I vehemently disagree with "inarguably".  IMO, passing data via
> registers is much more convenient.

Which is the most convenient approach is always dependent on data size and/or even how the data is produced/consumed. It's kind of a spectrum and we're just talking in the sense of probability. You are right that "inarguably" is arguable if the buffer is small enough to fit in registers, and the producer/consumer also has access to registers.

> 
> Even if you qualify your assertion with "data of arbitrary size unknown
> at build time", I still disagree.  Using the untrusted stack allows for
> trickery when a debugger is involved, other than that I see no
> advantages over allocating virtual memory and handing the pointer to the
> enclave at launch time.  Sure, it requires a few more lines of code to
> setup, but it's literally ~20 LoC out of thousands required to sign,
> build and launch an enclave, but it doesn't require playing games with
> the stack.

I'm NOT ruling out your approach.

And like you said, the untrusted stack enables certain trickery that helps debugging and also simplifies enclaves (even just a little). Then why are you trying to rule that out? Because of 9 LOC in vDSO?

> 
> Not to mention that the entire concept of using the untrusted stack is
> based on the assumption that the enclave is making ocalls, e.g.
> stateless enclaves or libraries that use a message queue have zero
> need/benefit for using the untrusted stack.

Don't get me wrong. I never said enclaves would require untrusted stack to make ocalls, or ocalls would require untrusted stack to make. It's just a generic approach for sharing/exchanging data. Some enclaves my need it, others may not.

My question still remains: why do you want to rule it out?

> > and is in fact being used for that purpose by almost all existing
> > enclaves to date.
> 
> That's a bit misleading, since almost all existing enclaves are built
> against Intel's SDK, which just so happens to unconditionally use the
> untrusted stack.  It's not like all enclave developers made a concious
> decision to use the untrusted stack.  If Intel rewrote the SDK to use a
> different method then one could argue that the new approach is the most
> common method of passing data.

Everything exists for a reason. It's unimportant what has been done. What matters is why that was done in that particular way. I was trying to inspire thinking.

> 
> > Given the expectation that this API will be used by all future SGX
> > application, it looks unwise to ban the most convenient and commonly
> > used approach for data exchange.
> >
> > Given an enclave can touch everything (registers and memory) of the
> > enclosing process, it's reasonable to restrict the enclave by means of
> > "calling convention" to allow the enclosing process to retain its
> > context. And for that purpose, SGX ISA does offer 2 registers (i.e.
> > RSP and RBP) for applications to choose. Instead of preserving RSP,
> > I'd prefer RBP, which will end up with more flexibility in all SGX
> > applications in future.
> 
> I disagree that the SGX ISA intends for applications to choose between
> preserving RSP and RBP, e.g. the SDM description of SSA.UR{B,S}P states:
> 
>   Non-Enclave (outside) {RBP,stack} pointer. Saved by EENTER, restored
> on AEX.
> 
> To me, the "Saved/restored" wording implies that URBP and URSP should
> *never* be touched by the enclave.  Sure, the proposed vDSO interface
> doesn't require RBP to be preserved, but only because the goal was to
> deviate from hardware as little as possible, not because anyone wants to
> encourage enclaves to muck with RBP.

I'm so sorry to tell you that you have misunderstood the SDM. If this is a common misunderstanding, I guess I could talk to the architect responsible for this SDM chapter to see if we could amend the language.

The purpose of restoring RSP is because software needs a stack to handle exception. Well, that's not 100% accurate because it's a user mode stack. Anyway, it tells the used part from the unused space in the stack. RBP on the other hand is NEVER required from interrupt/exception handling perspective, but we decided to add it because we'd like to offer a choice, just like I said earlier. The calling thread could then anchor its frame on either RSP or RBP.  
