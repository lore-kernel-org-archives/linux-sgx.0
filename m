Return-Path: <SRS0=mxub=YZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C919CA9ECF
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Nov 2019 13:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E27C2067D
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Nov 2019 13:25:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="SPgy5l5g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfKANZe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Nov 2019 09:25:34 -0400
Received: from UPDC19PA24.eemsg.mail.mil ([214.24.27.199]:2418 "EHLO
        UPDC19PA24.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbfKANZd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Nov 2019 09:25:33 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Nov 2019 09:25:32 EDT
X-EEMSG-check-017: 27466880|UPDC19PA24_ESA_OUT06.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.68,255,1569283200"; 
   d="scan'208";a="27466880"
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by UPDC19PA24.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 01 Nov 2019 13:16:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1572614180; x=1604150180;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=2j6u2sV7UephGxnJ3ambNAx+dFg+wboZYjnoVew9C5g=;
  b=SPgy5l5gLUDsNxhMhJfelIIEqBRMvtdaczIWfcH0pAlvkdAnrSbVOIH+
   1vf9y13HtUr4w5ZxD7x5e2S64tq8vZJ76UAUB4VP/F9yMror4Lb3Lfiti
   XQz5dyL93I9pP8kwawjLDqw83UoqBTrvHPk7t1frDAHJFviZ2Y/bhN272
   sboBDtaN35yyJBAxNrO7nCNxyjgSzDI7SvORQ5i4X5FfWS9NXyLMuvxsM
   c66oI9NfPBrNhIBhYc8UZ8XipRXupqVd6xjr7rfx2L4wg4I/y52yK6kcq
   9Lw/DZ4MptVFYAyMPzd0d39BRtxddQpLKVGTO8Ymvc0QL/+kz4s/X1Zy5
   Q==;
X-IronPort-AV: E=Sophos;i="5.68,255,1569283200"; 
   d="scan'208";a="34987254"
IronPort-PHdr: =?us-ascii?q?9a23=3AXObYjxXUZt6PKgEa0Fy7+258eqPV8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYZhaBu6dThVPEFb/W9+hDw7KP9fy5AipZucnK7C1KWacPfi?=
 =?us-ascii?q?dNsd8RkQ0kDZzNImzAB9muURYHGt9fXkRu5XCxPBsdMs//Y1rPvi/6tmZKSV?=
 =?us-ascii?q?3wOgVvO+v6BJPZgdip2OCu4Z3TZBhDiCagbb9oIxi6sAvcutMLjYd+KKs9xR?=
 =?us-ascii?q?TEr3tVcOlK2G1kIk6ekQzh7cmq5p5j9CpQu/Ml98FeVKjxYro1Q79FAjk4Km?=
 =?us-ascii?q?45/MLkuwXNQguJ/XscT34ZkgFUDAjf7RH1RYn+vy3nvedgwiaaPMn2TbcpWT?=
 =?us-ascii?q?S+6qpgVRHlhDsbOzM/7WrakdJ7gr5Frx29phx/24/Ub5+TNPpiZaPWYNcWSX?=
 =?us-ascii?q?NcUspNSyBNB4WxYIUVD+oFIO1WsY/zqVUTphe6HAWhCufixjpOi3Tr36M1zv?=
 =?us-ascii?q?4hHBnb0gI+EdIAsHfaotv7O6gdU++60KbGwC7fb/5Uwzrx9JTEfx4jrPyKQL?=
 =?us-ascii?q?l+cdDRyU4qFw7dk1uQtZLqPyuV1usTtWiQ8vduVee1hG4jrwF+vDiuzdorh4?=
 =?us-ascii?q?nSm40V0UvJ9Tl5wYkpJd24T1R3Ydi/EJRKrS2aOIx2Qt07TmxupS00xLoGuZ?=
 =?us-ascii?q?uhcygLzpQq3x3fZOKdc4iO/B3jUPydITBihHJqfr+0mhW88VC4x+HhWcS530?=
 =?us-ascii?q?xGoypYntXWqHwA2ALf5tKaRvZ740yvwyyA1xrJ5eFBOU00kK3bJIM/zbMojZ?=
 =?us-ascii?q?oTtFjDHjfxmEXrkK+abkUk9fas6+TgerjmuoWTN5V1igHjKaQigNC/AOQkPQ?=
 =?us-ascii?q?gOWGiX4+K826H4/ULlWrlKi/w2kq3BvJDbI8QUuLK5DhdI3oss5BuzFTer3M?=
 =?us-ascii?q?kCkXUZI19JZgiLg5XxN1HLOv/4DPO/g1q2kDdswvDLJqbhDYjWLnXYjLfgfa?=
 =?us-ascii?q?py605byAYpy9Bf/IhbBqsOIPL0RE/9rMbYAQMhMwyo3+bnD81w1oEEVmKVAa?=
 =?us-ascii?q?+ZM6TSvUWT5u01IOmMZ44VuDDjJPgj/PPuiX45mVkAfaimx5cXaXa4Huh4LE?=
 =?us-ascii?q?Wde3bjntABEWIStAokUOPqkEGCUSJUZ3uqW6I85zc7CJ+pDIvaRYCinqaB3C?=
 =?us-ascii?q?GlEZ1SfW1GFF+MHmnyd4meWPcDdjiSIsl/nTwAT7ShTJUh1R62vg/g17VnNv?=
 =?us-ascii?q?bU+jEftZ/729l45OzemAox9TNqFcSd1X+CT2VukmMPXT8207h1oVZhxVebza?=
 =?us-ascii?q?h4n/tYGMRX5/NIVAc6KJHdw/VhC9D9VQPMZcmJSFm4TdW8Gz0xTcw+w8UIY0?=
 =?us-ascii?q?ljH9WulBfD3zClA7UNjbyEGIQ08r7A33j2P8ty0XXG1LEkj1Q9RstPNGumhr?=
 =?us-ascii?q?Nw9gTKCY7JlFiZl6C3eqsGwC7N9WCDzWyUsEFfSg5wXr3PXWoDaUvOsdT5+k?=
 =?us-ascii?q?TCQqezBrs9LAtO19SOKqtQZd3vllVJWvHjNc/fY2K3h2e/GxKIyqmQY4rtfm?=
 =?us-ascii?q?UXxD/dB1QckwAP4XaGMhAzBjy/rG3ECjxiD1Dvb1nw/ul+snO7T1Q0zx2Nb0?=
 =?us-ascii?q?1517q65AQVheebS/MVxb8EuSEhqylqE1a5xd7ZF92Apw95dqVGfdw9+EtH1X?=
 =?us-ascii?q?7etwFlOJygL6dihkQbcwttuUPjzA93BZtdnsgqtnwq0BB+Jr6f0FNEbzmYx4?=
 =?us-ascii?q?z/OqXLKmnu+xCic6jW2knb0NmK5qgA8vA4q1H+vAGsDUci6Wto3MRV03SG+p?=
 =?us-ascii?q?XGFhYdUZX0Ukwv7Rh1u6naYjUh54PTzXBsKre7siXN2903Hucq0Bahf9BCMK?=
 =?us-ascii?q?OCDwLyEssaB9SwJ+wugVSmchUEPOVK/q4uI8ymb+eG2LKsPOt4hzKmjX5I4Y?=
 =?us-ascii?q?Bn3kKP7SV8Vu/J048Ewv6C2wuHVi38gUygssDxhYBLezUSEnCjxijjAY5bfr?=
 =?us-ascii?q?dycpoTCWeyP823wc1zh573VH5Z6F6sHVQG1NWpeRqPdVP92wJQ2F8WoXyhhS?=
 =?us-ascii?q?u30Th0nys1oaqY2SzE2/7iewYfOm5XWGliik/hLpKyj98HRkiobggomAG+5U?=
 =?us-ascii?q?b62adburhwL2nNTkdOfCj2KHpvUq+xtrqEfs5O54kksSRRUOSgf1+aTqTxrA?=
 =?us-ascii?q?cd0yPmB2Fe3iw0dym2upXlmBx3kH6dLHl3rHvWYsxwwRbf5NrBRf5NxDoGQy?=
 =?us-ascii?q?94iTjYB1SmItam482el43fveCmS2KhSppTfDHozYyatSu3/3ZqAQOlkPCznN?=
 =?us-ascii?q?3qCgk60Snn19Z0USXEtgrzYo7u166iK+JoYlFoBEPg68p9AoxxiZMwiYoK1n?=
 =?us-ascii?q?geh5Wa43wHnGTpPdpGx630dGANSiITw97J/Ajl31VuLnCOx4LiVnWQ2clhZ9?=
 =?us-ascii?q?6hYmMWxiI99cFKCL+Q7LNagSt1vkC0rQXLYfhyhj0d0+ch6GYGg+EVvwog1i?=
 =?us-ascii?q?GdAq0OHUlfJiHslAqH78q4rKpJYGaja7+w1FBxndq5FrGNvhlcWGrlepclBS?=
 =?us-ascii?q?Jw7d9wMFPW3H3z94HrYt/Qbd0Iux2VlRfAk/ZaKJYrmvUWgipnPHr3vWc5xO?=
 =?us-ascii?q?4jkRxuwZa6sZCdK2Vs4q25BAJYNj/raMMI4TztgqFensGZ34CrAJptACkEXJ?=
 =?us-ascii?q?ztTfiwCjIdqeznNxqSED07snqUBaTQEhKF6Edns33DCZ+qN3CRJHkW1thiRR?=
 =?us-ascii?q?+dJFBBjwAQRjk1gpk5FgWyzsz7bEh5/iwR5kL/qhZU0uJoKhj/UnvBqweyZD?=
 =?us-ascii?q?Y0SZqfLBlN4wFY+UjaLMye4fhvHy1C4pKhqwmNIHSBZwtUFWEJRlCEB1f7M7?=
 =?us-ascii?q?mq5NnA9fWYB+WnI/vVf7qBtfFeV+2JxZKz0opq5jOMNsKSMXl/C/00xFFOXW?=
 =?us-ascii?q?52G8vHgTUDUS8XmDzXb86duhi8/jd7rsel8PTkQAjv/5eAC6NOMdVz/BC7mb?=
 =?us-ascii?q?yDN/OKhClnMjZY1okAymTSxLgE3V4dljxhdzm3HrkbtC7NSr7QlbFTDxIBdy?=
 =?us-ascii?q?xzM85IvOoA2VxvMNTYidS97bd7jf8zBlENAV7ogMKqYooRKmK+NVXKAm6PNb?=
 =?us-ascii?q?KbNXvKxd36ZeW3TrgG38tOsBjlgiqWC0/uOHy4kjDtUx2+ebVXgDqzIA1VuI?=
 =?us-ascii?q?b7dA1kT2fkUoS1OVWALNZrgGhukvUPjXTQODtZaGMtfg=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2CjAABmL7xd/wHyM5BlGgEBAQEBAQEBAQMBAQEBEQEBA?=
 =?us-ascii?q?QICAQEBAYF9gW8FLGxUATIqhCiPC1QGgTaJY5FCCQEBAQEBAQEBAS0HAQIBA?=
 =?us-ascii?q?YFMgnQCg3skOBMCDgEBAQQBAQEBAQUDAQFshTcMgjspAYJtAQUjFUEQCxgCA?=
 =?us-ascii?q?iYCAlcGDQYCAQGCXz8BglIlD7IOgTKFToM+gUIGgQ4ojBEYeIEHgREngms+g?=
 =?us-ascii?q?mIEgTkGAQGDLoJeBJY6lziCLoIzhF6OHgYbmWWWbpM3IoFYKwgCGAghD4MoT?=
 =?us-ascii?q?xEUjA2FWyUDMQGBAwEBiycOF4IZAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 01 Nov 2019 13:16:19 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id xA1DGGL2019003;
        Fri, 1 Nov 2019 09:16:17 -0400
Subject: Re: [PATCH v23 12/24] x86/sgx: Linux Enclave Driver
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
 <173a196e-fa6b-23b8-c818-dfca6cdadcc6@tycho.nsa.gov>
 <20191031211721.GD10507@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <f91d788c-b372-8e2f-7ffb-995f501b5d6b@tycho.nsa.gov>
Date:   Fri, 1 Nov 2019 09:16:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191031211721.GD10507@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/31/19 5:17 PM, Jarkko Sakkinen wrote:
> On Wed, Oct 30, 2019 at 09:45:05AM -0400, Stephen Smalley wrote:
>> On 10/28/19 5:03 PM, Jarkko Sakkinen wrote:
>>> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
>>> can be used by applications to set aside private regions of code and
>>> data. The code outside the SGX hosted software entity is disallowed to
>>> access the memory inside the enclave enforced by the CPU. We call these
>>> entities as enclaves.
>>>
>>> This commit implements a driver that provides an ioctl API to construct
>>> and run enclaves. Enclaves are constructed from pages residing in
>>> reserved physical memory areas. The contents of these pages can only be
>>> accessed when they are mapped as part of an enclave, by a hardware
>>> thread running inside the enclave.
>>>
>>> The starting state of an enclave consists of a fixed measured set of
>>> pages that are copied to the EPC during the construction process by
>>> using ENCLS leaf functions and Software Enclave Control Structure (SECS)
>>> that defines the enclave properties.
>>>
>>> Enclave are constructed by using ENCLS leaf functions ECREATE, EADD and
>>> EINIT. ECREATE initializes SECS, EADD copies pages from system memory to
>>> the EPC and EINIT check a given signed measurement and moves the enclave
>>> into a state ready for execution.
>>>
>>> An initialized enclave can only be accessed through special Thread Control
>>> Structure (TCS) pages by using ENCLU (ring-3 only) leaf EENTER.  This leaf
>>> function converts a thread into enclave mode and continues the execution in
>>> the offset defined by the TCS provided to EENTER. An enclave is exited
>>> through syscall, exception, interrupts or by explicitly calling another
>>> ENCLU leaf EEXIT.
>>>
>>> The permissions, which enclave page is added will set the limit for maximum
>>> permissions that can be set for mmap() and mprotect(). This will
>>> effectively allow to build different security schemes between producers and
>>> consumers of enclaves. Later on we can increase granularity with LSM hooks
>>> for page addition (i.e. for producers) and mapping of the enclave (i.e. for
>>> consumers)
>>
>> Where do things stand wrt to ensuring that SGX cannot be used to introduce
>> executable mappings that were never authorized by the LSM (or never measured
>> by IMA)?
> 
> This was the latest discussion about that subject:
> 
> https://lore.kernel.org/linux-sgx/CALCETrWDLX68Vi4=9Dicq9ATmJ5mv36bzrc02heNYaHaBeWumQ@mail.gmail.com/

So, IIUC, that means that merging the driver will create a regression 
with respect to LSM control over executable mappings that will only be 
rectified at some future point in time if/when someone submits LSM hooks 
or calls to existing hooks to restore such control.  That doesn't seem 
like a good idea.  Why can't you include at least that basic level of 
control now?  It is one thing to defer finer grained control or 
SGX-specific access controls to the future - that I can understand.  But 
introducing a regression in the existing controls is not really ok.
