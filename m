Return-Path: <SRS0=rFfE=UN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC7AC31E49
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 00:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7BF720B7C
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 00:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbfFNAb2 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 20:31:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:52135 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfFNAb2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 20:31:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 17:31:26 -0700
X-ExtLoop1: 1
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jun 2019 17:31:23 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 13 Jun 2019 17:31:08 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.7]) with mapi id 14.03.0415.000;
 Thu, 13 Jun 2019 17:31:08 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Stephen Smalley <sds@tycho.nsa.gov>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "pmccallum@redhat.com" <pmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Thread-Topic: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks
 in SELinux
Thread-Index: AQHVH1ilvNGS2ZisK0eWTCWidam/YaaW7RmAgACMWICAAtC5gP//6xkwgAB92oD//55EwA==
Date:   Fri, 14 Jun 2019 00:31:07 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F65503F51@ORSMSX116.amr.corp.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <20190611220243.GB3416@linux.intel.com>
 <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F65503EDD@ORSMSX116.amr.corp.intel.com>
 <20190613231755.GD18385@linux.intel.com>
In-Reply-To: <20190613231755.GD18385@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTM0MmViYzktMDdiZS00YTE1LTgxYTgtZDYzOWY1NzhlOTA5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZHhPSUVuNnRUeVpNNWtwUGdBYUVCYUczbU12d2E5VSs4TzBPdWEyZ3B3aUM0S0tGUlQyaldjeFZ0NlwvdlRaQUIifQ==
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

> From: Christopherson, Sean J
> Sent: Thursday, June 13, 2019 4:18 PM
> 
> On Thu, Jun 13, 2019 at 04:03:24PM -0700, Xing, Cedric wrote:
> > > From: Stephen Smalley [mailto:sds@tycho.nsa.gov]
> > > Sent: Thursday, June 13, 2019 10:02 AM
> > >
> > > > My RFC series[1] implements #1.  My understanding is that Andy
> > > > (Lutomirski) prefers #2.  Cedric's RFC series implements #3.
> > > >
> > > > Perhaps the easiest way to make forward progress is to rule out
> the
> > > > options we absolutely *don't* want by focusing on the potentially
> > > > blocking issue with each option:
> > > >
> > > >    #1 - SGX UAPI funkiness
> > > >
> > > >    #2 - Auditing complexity, potential enclave lock contention
> > > >
> > > >    #3 - Pushing SGX details into LSMs and complexity of kernel
> > > > implementation
> > > >
> > > >
> > > > [1]
> > > > https://lkml.kernel.org/r/20190606021145.12604-1-
> sean.j.christopherson
> > > > @intel.com
> > >
> > > Given the complexity tradeoff, what is the clear motivating example
> for
> > > why #1 isn't the obvious choice? That the enclave loader has no way
> of
> > > knowing a priori whether the enclave will require W->X or WX?  But
> > > aren't we better off requiring enclaves to be explicitly marked as
> > > needing such so that we can make a more informed decision about
> whether
> > > to load them in the first place?
> >
> > Are you asking this question at a) page granularity, b) file
> granularity or
> > c) enclave (potentially comprised of multiple executable files)
> granularity?
> >
> > #b is what we have on regular executable files and shared objects (i.e.
> > FILE__EXECMOD). We all know how to do that.
> >
> > #c is kind of new but could be done via some proxy file (e.g.
> sigstruct file)
> > hence reduced to #b.
> >
> > #a is problematic. It'd require compilers/linkers to generate such
> > information, and proper executable image file format to carry that
> > information, to be eventually picked up the loader. SELinux doesn't
> have
> > PAGE__EXECMOD I guess is because it is generally considered
> impractical.
> >
> > Option #1 however requires #a because the driver doesn't track which
> page was
> > loaded from which file, otherwise it can no longer be qualified
> "simple". Or
> > we could just implement #c, which will make all options simpler. But I
> guess
> > #b is still preferred, to be aligned with what SELinux is enforcing
> today on
> > regular memory pages.o
> 
> Option #1 doesn't require (a).  The checks will happen for every page,
> but in the RFCs I sent, the policies are still attached to files and
> processes, i.e. (b).

I was talking at the UAPI level - i.e. your ioctl requires ALLOW_* at page granularity, hence #a.
