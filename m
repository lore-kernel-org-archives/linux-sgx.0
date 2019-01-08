Return-Path: <SRS0=ngON=PQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CA9C43387
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Jan 2019 20:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE07720660
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Jan 2019 20:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfAHUJI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Jan 2019 15:09:08 -0500
Received: from mga18.intel.com ([134.134.136.126]:51772 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729548AbfAHT1Q (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Jan 2019 14:27:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2019 11:27:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,455,1539673200"; 
   d="scan'208";a="113153477"
Received: from kmsmsx153.gar.corp.intel.com ([172.21.73.88])
  by fmsmga007.fm.intel.com with ESMTP; 08 Jan 2019 11:27:12 -0800
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.246]) by
 KMSMSX153.gar.corp.intel.com ([169.254.5.199]) with mapi id 14.03.0415.000;
 Wed, 9 Jan 2019 03:27:11 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Andy Lutomirski" <luto@kernel.org>
CC:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: x86/sgx: uapi change proposal
Thread-Topic: x86/sgx: uapi change proposal
Thread-Index: AQHUl3CouNmOMJQZHU2YX8Dh54+gQaWFODMAgAAIjACAAAbWAIAAVlWAgADM8wCAAnSJgIAc/6rw
Date:   Tue, 8 Jan 2019 19:27:11 +0000
Message-ID: <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
In-Reply-To: <20181221162825.GB26865@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzEzZDI1NGYtMmQxZC00OTRmLThiOGQtZjRhZWQ5ZmQ2MDM4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiekhcL01jWDNMM0drSkxwdW1xYVBTQXpWN3dFaldPd01EcVViSTFZSmIwOE9XNk5KN1hQejk5RWs2NGNFMHJNUnIifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> >
> > Can one of you explain why SGX_ENCLAVE_CREATE is better than just
> > opening a new instance of /dev/sgx for each encalve?
> 
> Directly associating /dev/sgx with an enclave means /dev/sgx can't be used
> to provide ioctl()'s for other SGX-related needs, e.g. to mmap() raw EPC and
> expose it a VM.  Proposed layout in the link below.  I'll also respond to
> Jarkko's question about exposing EPC through /dev/sgx instead of having
> KVM allocate it on behalf of the VM.
> 
> https://lkml.kernel.org/r/20181218185349.GC30082@linux.intel.com

Hi Sean,

Sorry for replying to old email. But IMHO it is not a must that Qemu needs to open some /dev/sgx and allocate/mmap EPC for guest's virtual EPC slot, instead, KVM could create private slot, which is not visible to Qemu, for virtual EPC, and KVM could call core-SGX EPC allocation API directly.

I am not sure what's the good of allowing userspace to alloc/mmap a raw EPC region? Userspace is not allowed to touch EPC anyway, expect enclave code.

To me KVM creates private EPC slot is cleaner than exposing /dev/sgx/epc and allowing userspace to map some raw EPC region. 

Thanks,
-Kai
