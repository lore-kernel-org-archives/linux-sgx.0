Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D38AC433F5
	for <linux-sgx@archiver.kernel.org>; Sun, 15 May 2022 03:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiEODf0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 14 May 2022 23:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiEODfX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 14 May 2022 23:35:23 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACCA3896
        for <linux-sgx@vger.kernel.org>; Sat, 14 May 2022 20:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652585722; x=1684121722;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SNWtjbq1HZd5ViYWuDd2lVj7MyyxPNwWhO8LZH4QSmg=;
  b=n1YhCbTc3cLR23NHNjfbFplyZTo3CCFdl67fq6PcACULru0QDa1e43W8
   TDeokkDaNgVHLz+ZEKPvKgU0wupjhbc91o4d8lH8qEClkIovfu5ZPqJcY
   RnA7FXTyUEc01qpDjXUzN8CXQKKE5VKTANCgqiJzi+Dk+1H2VqlwB27eq
   tnWOSk8/U0pI05XyyEQM+BSf/GaJjWYfDnxpe3Q1vGmmRIWKvv0v7KzM6
   3Cup0r9C942wvrqQDKEOqUqXjU+QarXie+zjF8yr2wo0AWZfF8jjQM5Nu
   tyUn0XEDT3eV3/M8NdAzgak3xBcv4laiGJVQogrcR9L1RyHkDPXBpatyx
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10347"; a="356999742"
X-IronPort-AV: E=Sophos;i="5.91,227,1647327600"; 
   d="scan'208";a="356999742"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2022 20:35:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,227,1647327600"; 
   d="scan'208";a="543835528"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga006.jf.intel.com with ESMTP; 14 May 2022 20:35:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sat, 14 May 2022 20:35:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sat, 14 May 2022 20:35:20 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Sat, 14 May 2022 20:35:20 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Du, Fan" <fan.du@intel.com>
Subject: RE: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
Thread-Topic: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
Thread-Index: AQHYZBxTUIPqMGLJAUyslYHn09JRdq0Z8T+AgAGseACAAb2KgP//qaowgAFSKQCAAPmsYA==
Date:   Sun, 15 May 2022 03:35:20 +0000
Message-ID: <5b6ad3e2af614caf9b41092797ffcd86@intel.com>
References: <20220510031646.3181306-1-zhiquan1.li@intel.com>
 <YnuQJaM0p7gD5qel@kernel.org>
 <d8e3f194-bd52-4405-8cdd-db8710e71509@intel.com> <Yn5tPS0aLXBgHtYT@iki.fi>
 <55ffd9475f5d46f68dd06c4323bec871@intel.com>
 <35284def-ca7f-d42b-164f-1c49eb8977ee@intel.com>
In-Reply-To: <35284def-ca7f-d42b-164f-1c49eb8977ee@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiBBbnkgbWFjaGluZSBjaGVjayBleGNlcHRpb24gKCNNQykgdGhhdCBvY2N1cnMgYWZ0ZXIgSW50
ZWwgU0dYIGlzIGZpcnN0IGVuYWJsZXMNCj4gY2F1c2VzIEludGVsIFNHWCB0byBiZSBkaXNhYmxl
ZCwgKENQVUlELlNHWF9MZWFmLjA6RUFYW1NHWDFdID09IDApLiBJdCBjYW5ub3QgYmUNCj4gZW5h
YmxlZCB1bnRpbCBhZnRlciB0aGUgbmV4dCByZXNldC4gIg0KDQpUaGF0IHBhcnQgaXMgb3V0IG9m
IGRhdGUuIEEgbWFjaGluZSBjaGVjayB1c2VkIHRvIGRpc2FibGUgU0dYIHN5c3RlbS13aWRlLiBJ
dCBub3cganVzdA0KZGlzYWJsZXMgdGhlIGVuY2xhdmUgdGhhdCB0cmlnZ2VyZWQgdGhlIG1hY2hp
bmUgY2hlY2suDQoNCklzIHRoYXQgdGV4dCBzdGlsbCBpbiB0aGUgbGF0ZXN0IFNETSAodmVyc2lv
biAwNzcsIEFwcmlsIDIwMjIpPw0KDQotVG9ueQ0K
