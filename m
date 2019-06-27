Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A469CC004E6
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 20:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 855AB20665
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 20:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfF0UdA convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 16:33:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:11761 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfF0UdA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Jun 2019 16:33:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 13:32:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,425,1557212400"; 
   d="scan'208";a="153164120"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga007.jf.intel.com with ESMTP; 27 Jun 2019 13:32:59 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX108.amr.corp.intel.com ([169.254.2.227]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 13:32:58 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
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
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: RE: [PATCH v20 22/28] x86/traps: Attempt to fixup exceptions in
 vDSO before signaling
Thread-Topic: [PATCH v20 22/28] x86/traps: Attempt to fixup exceptions in
 vDSO before signaling
Thread-Index: AQHVK2zZgzHDWzFJwEGh+L3RXyNlXaav93CQ
Date:   Thu, 27 Jun 2019 20:32:58 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551B873@ORSMSX116.amr.corp.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190417103938.7762-23-jarkko.sakkinen@linux.intel.com>
 <20190625154341.GA7046@linux.intel.com>
In-Reply-To: <20190625154341.GA7046@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjA1NDc5NTktYTdlOC00ZmM5LTgzYTYtN2E3MmQ5Y2Q0NWRkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTlV4b3BLVFNDUEI1ZGw0Y3lzU1BwbnY4RlZsRWZuQ0NHRGtpdzY1K2NvMTFQTUkxOGtpT01hK053SmxJaGVYbiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
> owner@vger.kernel.org] On Behalf Of Jarkko Sakkinen
> Sent: Tuesday, June 25, 2019 8:44 AM
> 
> I went through the vDSO changes just to revisit couple of details that I
> had forgotten. Sean, if you don't mind I'd squash this and prepending
> patch.

Just a reminder that #DB/#BP shall be treated differently because they are used by debuggers. So instead of branching to the fixup address, the kernel shall just signal the process. 

> 
> Is there any obvious reason why #PF fixup is in its own patch and the
> rest are collected to the same patch? I would not find it confusing if
> there was one patch per exception but really don't get this division.
> 
> /Jarkko
