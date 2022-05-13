Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C67C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 13 May 2022 16:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377528AbiEMQfm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 13 May 2022 12:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378231AbiEMQfl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 13 May 2022 12:35:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B29015814
        for <linux-sgx@vger.kernel.org>; Fri, 13 May 2022 09:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652459739; x=1683995739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uCTGe8MnjjZBq9Y9EwLauwIUan1gjbNE783BQeb8Dd8=;
  b=A0Hr8p2EfQB1ZTZoO9t/6MaMgQfTofCB3pflxCjWtQ6NeRdcPiabpBXO
   c6IpK2Gy1/nliRhq7oWYN4/KfIo5t4N1YJTUWbKHQytutPgImiODLS5v7
   Thv49hxmA778Xbp7IqWeTH4hffpkj5A1cj+6/s5oDRUhwOPZGxbtBlQ3A
   wGGOfoYVQf/iUSvup7KnmgewkoZeZdVRdO4g//I8lOo1S5KNQ6w071T29
   SXlYHh8q/AsWkifBPuoH/ezuISswatq/08sK1IFbg43IEVyyW4DOlKGuI
   Hh/ZCQ8QbBWz1FexdSPj0AUUg7WUX5TapIna9oOD59K/ArALPuvp4mhcP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="333379612"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="333379612"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 09:35:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="659151276"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 13 May 2022 09:35:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 09:35:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 09:35:37 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Fri, 13 May 2022 09:35:37 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Du, Fan" <fan.du@intel.com>
Subject: RE: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
Thread-Topic: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
Thread-Index: AQHYZBxTUIPqMGLJAUyslYHn09JRdq0Z8T+AgAGseACAAb2KgP//qaow
Date:   Fri, 13 May 2022 16:35:36 +0000
Message-ID: <55ffd9475f5d46f68dd06c4323bec871@intel.com>
References: <20220510031646.3181306-1-zhiquan1.li@intel.com>
 <YnuQJaM0p7gD5qel@kernel.org>
 <d8e3f194-bd52-4405-8cdd-db8710e71509@intel.com> <Yn5tPS0aLXBgHtYT@iki.fi>
In-Reply-To: <Yn5tPS0aLXBgHtYT@iki.fi>
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

Pj4gRG8geW91IHRoaW5rIHRoZSBwcm9jZXNzZXMgc2hhcmluZyB0aGUgc2FtZSBlbmNsYXZlIG5l
ZWQgdG8gYmUga2lsbGVkLA0KPj4gZXZlbiB0aGV5IGhhZCBub3QgdG91Y2hlZCB0aGUgRVBDIHBh
Z2Ugd2l0aCBoYXJkd2FyZSBlcnJvcj8NCj4+IEFueSBpZGVhcyBhcmUgd2VsY29tZS4NCj4NCj4g
SSBkbyBub3QgdGhpbmsgdGhlIHBhdGNoIHNldCBpcyBnb2luZyB0byB3cm9uZyBkaXJlY3Rpb24u
IFRoaXMgZGlzY3Vzc2lvbg0KPiB3YXMganVzdCBtaXNzaW5nIGZyb20gdGhlIGNvdmVyIGxldHRl
ci4NCg0KSSB3YXMgdW5kZXIgdGhlIGltcHJlc3Npb24gdGhhdCB3aGVuIGFuIGVuY2xhdmUgcGFn
ZSB0cmlnZ2VycyBhIG1hY2hpbmUgY2hlY2sNCnRoZSB3aG9sZSBlbmNsYXZlIGlzIChzb21laG93
KSBtYXJrZWQgYmFkLCBzbyB0aGF0IGl0IGNvdWxkbid0IGJlIGVudGVyZWQgYWdhaW4uDQoNCktp
bGxpbmcgb3RoZXIgcHJvY2Vzc2VzIHdpdGggdGhlIHNhbWUgZW5jbGF2ZSBtYXBwZWQgd291bGQg
cGVyaGFwcyBiZSBvdmVya2lsbCwNCmJ1dCB0aGV5IGFyZSBnb2luZyB0byBmaW5kIHRoYXQgdGhl
IGVuY2xhdmUgaXMgImRlYWQiIG5leHQgdGltZSB0aGV5IHRyeSB0byB1c2UgaXQuDQoNCi1Ub255
DQo=
