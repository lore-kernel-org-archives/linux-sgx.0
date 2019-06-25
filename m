Return-Path: <SRS0=BFWe=UY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F245FC48BD5
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 21:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C44CF20663
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 21:09:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="ccI6E0g9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfFYVJr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Jun 2019 17:09:47 -0400
Received: from upbd19pa11.eemsg.mail.mil ([214.24.27.86]:53404 "EHLO
        upbd19pa11.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYVJr (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 25 Jun 2019 17:09:47 -0400
X-EEMSG-check-017: 225083631|UPBD19PA11_EEMSG_MP11.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by upbd19pa11.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 25 Jun 2019 21:09:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1561496982; x=1593032982;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=GCZ12GQVE0JzDpgJ8JjxiRMbpPENa9LWIKvHi67t/pg=;
  b=ccI6E0g9jQlq+gf2cj43eB4Sfd4a7olJryggxZcf8zEIQ1f3UXbNYiD5
   50rrGcmyBHRgjxyy0eej7roDwpZnvqiQ+VCyGHvfFuGt4wcO62YstD8jf
   hAUnG040LKeAuCfJ6P/zljZHyaLKRMX1k57UTkfdYfINo5tEPUNM2D4AV
   IXMyhClhfFfpLsZaqlMLaA1FzkPTw6mGcMnfkFAxQrJon5YFAa6VZ0cCW
   n0jgGdueX5X0UZlMNmBXmvXya86B/ydsQviZr0EHpHoMXLR+LQ3EJMlIJ
   xczZP2b4Z9sV8+3KyvX7+RgOf5PsthjgujVR1+UY/oi9F3uxZ6N/wd6Yi
   Q==;
X-IronPort-AV: E=Sophos;i="5.63,417,1557187200"; 
   d="scan'208";a="29420701"
IronPort-PHdr: =?us-ascii?q?9a23=3AdaKfOhSSKt/AQzRrH3FyHsMpP9psv+yvbD5Q0Y?=
 =?us-ascii?q?Iujvd0So/mwa67YxaFt8tkgFKBZ4jH8fUM07OQ7/m6HzVcqs/b4DhCKMUKC0?=
 =?us-ascii?q?Zcz51O3kQJO42sMQXDNvnkbig3ToxpdWRO2DWFC3VTA9v0fFbIo3e/vnY4Ex?=
 =?us-ascii?q?T7MhdpdKyuQtaBx8u42Pqv9JLNfg5GmCSyYa9oLBWxsA7dqtQajZFtJ6os1B?=
 =?us-ascii?q?fFuGZEdutZyW91O16enAv36sOs8JJ+6ShdtO8t+9NaXanmY6g0SKFTASg7PW?=
 =?us-ascii?q?wy+MDlrwTIQxGV5nsbXGUWkx5IDBbA4RrnQJr/sTb0u/Rk1iWCMsL4Ub47WT?=
 =?us-ascii?q?K576d2UxDokzsINyQ48G7MlMN9ir9QrQ+7qBx+x47UZ5yVNOZ7c6jAc94WWX?=
 =?us-ascii?q?ZNU8BMXCFaHIiyc5UAAPYAPeZAronyuV0OrQelBQKxAO/j0yJEimPq0aE/1e?=
 =?us-ascii?q?kuHxvG3Ag9FNwQtnraosj+OKMLXe21yKTEyDPOZO5U1zjg8ojFag0vr++CXb?=
 =?us-ascii?q?xwcsTfx0cgGAzHgVqMpoLoJC+V2+YXvmSH8+ZtW+Cihmg6oA9xuDivwcIsh5?=
 =?us-ascii?q?HUiIIJ1F/E7SV5z5gzJdalVUB7ZMSrEJ9Uty6EN4p9X8QvQ3p1tyYh0bAGpZ?=
 =?us-ascii?q?66czQKyJQg3RLfbeeHfJKS7hLsU+aRPy51iXR4c7y8nxa/6VWsx+LzW8Wu0F?=
 =?us-ascii?q?tGszBJnsfDu3wTzRDf986KQeZn8Ei7wzaAzQXT5/lBIUAziKXUNYYswqU1lp?=
 =?us-ascii?q?oPqUTDGTL2mFnugK+WaEok/u+o5vz7Yrr8vJ+cNpJ0ihrkPqQyms2wHeQ4Mg?=
 =?us-ascii?q?8UU2id5eu8z6Hs8Vf8QLVLiv06iqjZsJbEKsQHvqO1HgBY34k55xu/Ejuqys?=
 =?us-ascii?q?oUkHYZIF5fZR6Ll43pNEvPIPD8A/e/mVOskDJzyvDdI7LhGY7ALmTDkbj9fb?=
 =?us-ascii?q?Z97FRQyAwozd9F/Z5UBbYBIOzrVk/rqNPYFgM5MxCzw+v/FNpyyJ4RWXiOAq?=
 =?us-ascii?q?CFKq/Tvl6I5uQgI+SXZY8Vvir9JOYh5/L0kXA5nlodd7Gz3ZQLcHC4AuhmI0?=
 =?us-ascii?q?KBbHr3nNgOC2EKshA8TODwlFKCUSRTZ3epX6Ig4TE7EIKmApnZRoC2h7yB2j?=
 =?us-ascii?q?y2HpxQZmBaFF+MFW3keJmDW/cJcCiSONNukiQYVbi9TI8szROuuxXgy7pkLe?=
 =?us-ascii?q?rU/TcUtYn529h25O3TlBcy+iJyD8mG12GNTmd0nn4HRjMs3aB/p1B9xUmH0a?=
 =?us-ascii?q?Rin/NYEtlT7etTUggmLZ7c0/B6C9fqVwLFf9eJTkumQ9q/DTEqQdIwzMQDY1?=
 =?us-ascii?q?hyG9q8lBDPxSmqDKEPl7yNGpM09rjQ33/rJ8Zy03zGzrUuj0E6QstTMm2rnq?=
 =?us-ascii?q?p/9wnVB47UnESVjr2qeroA0y7Q7meDzHaOvUFBXA51VqXKQG0fZk/Iotni+E?=
 =?us-ascii?q?PCQKGhCa49PgtC18GCMK1KZcPtjVlcQ/fjItveaXqrm2isHRaI2q+MbI3ydm?=
 =?us-ascii?q?UGwirdDEkEkwYO/XeJLgU+GCihrHzEDDB0FlLgfVns8e9gp3O/VEM0yBuKb0?=
 =?us-ascii?q?J53bqv5hEVneCcS+8U3r8ctiYhqjF0HFK8393MDtqMvRZucL9GYdM6+1hIy3?=
 =?us-ascii?q?jZtxBmPpG7LqBigEIefBpzv0/0yxp3DYBAm9AwrHw21ApyNb6Y0FRZejyEx5?=
 =?us-ascii?q?/wIaPYK2no8BC0d6HW2kvR0MuY+qcL9vs4sU7uvACvFko+7Xpn18NZ3Geb5p?=
 =?us-ascii?q?XPFAASS47+Ul4r9xhmoLHXeis954bT1X12K6m0syTC1skvBOQ/zxavYdZfPL?=
 =?us-ascii?q?mDFA/oHM0QH9KuJ/Aym1i1chIEO/hf+7MuMMO4afSKwq6rM/xmnDK9k2tH5p?=
 =?us-ascii?q?tw0kOK9ypgVOHI24wJzO2f3guCTz38lkuustjrmYBYYjEfBm6/yTX4BI5Wfa?=
 =?us-ascii?q?ByfpgECX2oI8KpwtVynZntW2RX9FS7HVMJxNepeQaOb1z6xQBQ11oYoWCnmS?=
 =?us-ascii?q?uiyDx5iD8prq2F3CzS2evichsHO2FRSGZ+ilfsJJC+j8oGU0iwcwgpiByl6F?=
 =?us-ascii?q?71x6hBuqt/IHLeTllOfyj0MW5iVq+wtruebMJV9JwotiBXA6yAZgXQer/7rF?=
 =?us-ascii?q?9S+C7vBWpVjnhvfDymoJTy2Qx7jm21LXBvoX6fcsZ1k1OXrvfcX/9Kwj0eRC?=
 =?us-ascii?q?Rikj7RQhCHMtCvtffe38PYv+m4EWDnXZ1JcDL3ypuAuTGg4mtCABujkvT1kd?=
 =?us-ascii?q?riR0xy8ybh1NptHR7BrxX9ZITtn/C4OPhkfU4uH1b/6Mt8F4dWloo2mYFW2H?=
 =?us-ascii?q?4Gi5HT9n0CxzTdK9JejJniYWINSDhD+Nvc5AzoyQU3NX6S757oXXWahM16bp?=
 =?us-ascii?q?+1ZX1AiXF11NxDFKrBtO8MpiByuFft6FuMMPU=3D?=
X-IPAS-Result: =?us-ascii?q?A2AVAQDYjBJd/wHyM5BmGwEBAQEDAQEBBwMBAQGBZ4FtK?=
 =?us-ascii?q?oE3BTKEPZJ5TQEBAQEBAQaBESWJU5EOCQEBAQEBAQEBATQBAgEBhEACgnUjO?=
 =?us-ascii?q?BMBAwEBAQQBAQEBBAEBbIpDgjopAYJmAQEBAQMjFUEQCxUBAgICJgICVwYBD?=
 =?us-ascii?q?AgBAYJfP4F3FKVggTGFR4MqgUaBDCiLXhd4gQeBOAyCXz6HToJYBI4hhiaVT?=
 =?us-ascii?q?QmCF4IekUcGG5dOLYx7mR0hgVgrCAIYCCEPgyiRHyMDgTYBAY9cAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 25 Jun 2019 21:09:41 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5PL9enW027674;
        Tue, 25 Jun 2019 17:09:40 -0400
Subject: Re: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov>
Date:   Tue, 25 Jun 2019 17:09:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/21/19 5:22 PM, Xing, Cedric wrote:
>> From: Christopherson, Sean J
>> Sent: Wednesday, June 19, 2019 3:24 PM
>>
>> Intended use of each permission:
>>
>>    - SGX_EXECDIRTY: dynamically load code within the enclave itself
>>    - SGX_EXECUNMR: load unmeasured code into the enclave, e.g. Graphene
> 
> Why does it matter whether a code page is measured or not?

It won't be incorporated into an attestation?

> 
>>    - SGX_EXECANON: load code from anonymous memory (likely Graphene)
> 
> Graphene doesn't load code from anonymous memory. It loads code dynamically though, as in SGX_EXECDIRTY case.

So do we expect EXECANON to never be triggered at all?

> 
>>    - SGX_EXECUTE: load an enclave from a file, i.e. normal behavior
> 
> Why is SGX_EXECUTE needed from security perspective? Or why isn't FILE__EXECUTE sufficient?

Splitting the SGX permissions from the regular ones allows distinctions 
to be made between what can be executed in the host process and what can 
be executed in the enclave.  The host process may be allowed 
FILE__EXECUTE to numerous files that do not contain any code ever 
intended to be executed within the enclave.



