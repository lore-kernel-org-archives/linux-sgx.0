Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F9AC31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 19:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E482221721
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 19:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbfFMTpZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 15:45:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:11849 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbfFMTpZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 15:45:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 12:45:24 -0700
X-ExtLoop1: 1
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jun 2019 12:45:24 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX110.amr.corp.intel.com ([169.254.10.60]) with mapi id 14.03.0415.000;
 Thu, 13 Jun 2019 12:45:24 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [PATCH 4/7] x86/sgx: Allow userspace to add multiple pages in
 single ioctl()
Thread-Topic: [PATCH 4/7] x86/sgx: Allow userspace to add multiple pages in
 single ioctl()
Thread-Index: AQHVG9fN3B2slUZtXkW2FoewZrrMEqaZP8EAgAEOZwD//7g+QA==
Date:   Thu, 13 Jun 2019 19:45:23 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F65503CD4@ORSMSX116.amr.corp.intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-5-sean.j.christopherson@intel.com>
 <f2e88e83-e5f6-fecb-c180-b75be1d1a582@fortanix.com>
 <20190613165130.GB5850@linux.intel.com>
In-Reply-To: <20190613165130.GB5850@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjQ2OWZjM2EtZjExMi00ZTFlLWI1MzAtNTQzMDI1NzVkYmUzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoienpERmh2MGEzQlVDYzFKcUIrc3FqR3FGM2tQeDFQSiszWGMxY2k0YnNpZmtaR011Y0NqZDkrczJvalJhWDRabCJ9
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
> Sent: Thursday, June 13, 2019 9:52 AM
> 
> On Thu, Jun 13, 2019 at 12:43:42AM +0000, Jethro Beekman wrote:
> > On 2019-06-05 12:48, Sean Christopherson wrote:
> > >...to improve performance when building enclaves by reducing the
> > >number of user<->system transitions.  Rather than provide arbitrary
> > >batching, e.g. with per-page SECINFO and mrmask, take advantage of
> > >the fact that any sane enclave will have large swaths of pages with
> > >identical properties, e.g. code vs. data sections.
> > >
> > >For simplicity and stability in the initial implementation, loop over
> > >the existing add page flow instead of taking a more agressive
> > >approach, which would require tracking transitions between VMAs and
> > >holding mmap_sem for an extended duration.
> > >
> > >On an error, update the userspace struct to reflect progress made,
> e.g.
> > >so that the ioctl can be re-invoked to finish adding pages after a
> > >non- fatal error.
> > >
> > >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > >---
> > >  Documentation/x86/sgx/3.API.rst        |   2 +-
> > >  arch/x86/include/uapi/asm/sgx.h        |  21 ++--
> > >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 128
> > >+++++++++++++++++--------
> > >  3 files changed, 98 insertions(+), 53 deletions(-)
> > >
> > >diff --git a/Documentation/x86/sgx/3.API.rst
> > >b/Documentation/x86/sgx/3.API.rst index b113aeb05f54..44550aa41073
> > >100644
> > >--- a/Documentation/x86/sgx/3.API.rst
> > >+++ b/Documentation/x86/sgx/3.API.rst
> > >@@ -22,6 +22,6 @@ controls the `PROVISON_KEY` attribute.
> > >  .. kernel-doc:: arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > >     :functions: sgx_ioc_enclave_create
> > >-               sgx_ioc_enclave_add_page
> > >+               sgx_ioc_enclave_add_region
> > >                 sgx_ioc_enclave_init
> > >                 sgx_ioc_enclave_set_attribute diff --git
> > >a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> > >index 9ed690a38c70..30d114f6b3bd 100644
> > >--- a/arch/x86/include/uapi/asm/sgx.h
> > >+++ b/arch/x86/include/uapi/asm/sgx.h
> > >@@ -12,8 +12,8 @@
> > >  #define SGX_IOC_ENCLAVE_CREATE \
> > >  	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create) -#define
> > >SGX_IOC_ENCLAVE_ADD_PAGE \
> > >-	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
> > >+#define SGX_IOC_ENCLAVE_ADD_REGION \
> > >+	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_region)
> > >  #define SGX_IOC_ENCLAVE_INIT \
> > >  	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> > >  #define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \ @@ -32,21 +32,22 @@ struct
> > >sgx_enclave_create  {
> > >  };
> > >  /**
> > >- * struct sgx_enclave_add_page - parameter structure for the
> > >- *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> > >- * @addr:	address within the ELRANGE
> > >- * @src:	address for the page data
> > >- * @secinfo:	address for the SECINFO data
> > >- * @mrmask:	bitmask for the measured 256 byte chunks
> > >+ * struct sgx_enclave_add_region - parameter structure for the
> > >+ *                                 %SGX_IOC_ENCLAVE_ADD_REGION ioctl
> > >+ * @addr:	start address within the ELRANGE
> > >+ * @src:	start address for the pages' data
> > >+ * @size:	size of region, in bytes
> > >+ * @secinfo:	address of the SECINFO data (common to the entire
> region)
> > >+ * @mrmask:	bitmask of 256 byte chunks to measure (applied per 4k
> page)
> > >   */
> > >-struct sgx_enclave_add_page {
> > >+struct sgx_enclave_add_region {
> > >  	__u64	addr;
> > >  	__u64	src;
> > >+	__u64	size;
> > >  	__u64	secinfo;
> > >  	__u16	mrmask;
> >
> > Considering:
> >
> > 1. I might want to load multiple pages that are not consecutive in
> memory.
> > 2. Repeating mrmask (other than 0 or ~0) doesn't really make sense for
> > ranges.
> >
> > I'd be in favor of an approach that passes an array of
> > sgx_enclave_add_page instead.
> 
> I'm not opposed to taking an array.  The region approach seemed simpler
> at first glance, but that may not be the case, especially if we get rid
> of the workqueue.  I'll play around with it.

In practice, ELF segments are usually mapped continuously in memory. Other components of an enclave such as heaps and stack, are usually trunks of zeroes. I'd just stay simple. After all, there's no requirement that everything has to be done in a single ioctl.
