Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3157C48BD7
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 13:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 800C720828
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 13:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="UvdXmhOy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfF0Nl7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 09:41:59 -0400
Received: from upbd19pa09.eemsg.mail.mil ([214.24.27.84]:32098 "EHLO
        UPBD19PA09.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0Nl7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 27 Jun 2019 09:41:59 -0400
X-EEMSG-check-017: 206277185|UPBD19PA09_EEMSG_MP9.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by UPBD19PA09.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 27 Jun 2019 13:41:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1561642911; x=1593178911;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=+L2MvjrputUjxROu/IGmwLeO9XvJ1XahPS1+06A214s=;
  b=UvdXmhOyw+eu+QeXBvGKuDOMKyJy8FNtHvwVDC18RxuHRj4yDQ5Og6kI
   eXDd9VGhUC+BJ55FWaDGTYj0aHomz+ayHph2bYbQzt0PL5AfGekmFl4Hc
   WVX9lCHHcN8D2bz5ci3CtSRrS/t3Zg+INBS5hdFm4yIAtriQKaWwgHY39
   I+z/qKb5OkJYfcjqUKYzfTa92EiOkZqaPHIy+s86LhYU9mD04yuSDr3C1
   O2tyaEL6rS3Fv2K2RIkG/FHolipOfEbfdDDr3VVQlgLhdrkczf3c5X8st
   lcJYtyXi76+ln/+ratzarLCNR63VqazMo2g2whYCrtyETmVIZBvDg2DW6
   A==;
X-IronPort-AV: E=Sophos;i="5.63,423,1557187200"; 
   d="scan'208";a="29496468"
IronPort-PHdr: =?us-ascii?q?9a23=3AjJqd7hVMaUV33JO6PUhB/JP4+LPV8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYZReOvqdThVPEFb/W9+hDw7KP9fy5AypZsd3f7jhCKMUKC0?=
 =?us-ascii?q?Zcz51O3kQJO42sMQXDNvnkbig3ToxpdWRO2DWFC3VTA9v0fFbIo3e/vnY4Ex?=
 =?us-ascii?q?T7MhdpdKyuQtaBx8u42Pqv9JLNfg5GmCSyYa9oLBWxsA7dqtQajZFtJ6os1B?=
 =?us-ascii?q?fFuGZEdudZyW5pJF+YghLw6tut8JJ5/Clcpu8t+9RcXanmeqgzUKBVAikhP2?=
 =?us-ascii?q?0p/sPgqAPNTRGI5nsSU2UWlgRHDg3Y5xzkXZn/rzX3uPNl1CaVIcP5Q7Y0WS?=
 =?us-ascii?q?+/76hwUx/nlD0HNz8i/27JjMF7kb9Wrwigpxx7xI7UfZ2VOf9jda7TYd8WWW?=
 =?us-ascii?q?xMVdtKWidfHo2zcZcAD+sZPeZZsYb9oUcOrQCjDgWoHe/j1yNEimPz0aA83e?=
 =?us-ascii?q?shCwXG1xE+EdwIvnrfsdH5OL4SXO2xyaXFyyjIYfFL1jfn8IXGbw4vof+MU7?=
 =?us-ascii?q?xzf8Tex0YgGAHZgVufsoHlIzGY2/4Rv2SH4edtV+SigHMnpQFrpTivw98hhJ?=
 =?us-ascii?q?TVho0L0lDE9Tt2wIAoLtOlTU50e9qkEJ9OuCCaKoB7RdgiTHxzuCsh1r0HuY?=
 =?us-ascii?q?K0fCgNyJg9wR7fcOaIf5KH4hLkSuacODF1j29mdrKnnxu+7Eetx+LmWsS0zV?=
 =?us-ascii?q?pGtDRJn9bSunwXyhDe7NWMROFn8Ue7wzmP0hje6uRDIU8pi6XWM4Uhwrsslp?=
 =?us-ascii?q?oLtkTDAzP2lF32jKCIckUk/fCl6/j9bbX8p5+cKpR0hhviMqUuhsO/AeM4Ph?=
 =?us-ascii?q?IIX2eH4uSzyKfv/Uj4QLVOlvE2k6/Zv47GJckDu6K0DABY3pwj5hqiFTuqzt?=
 =?us-ascii?q?sVkWcdIF5YYB6HipLmO1DKIPD2F/e/hFGsnS9wx//bJb3sGYnNL3jfn7fher?=
 =?us-ascii?q?Zx8UhcyBEpwtxF6JJUDa8BLOrpWkDtrNzYEgM5MwuszublEtp9zIAeWWGIAq?=
 =?us-ascii?q?ODK6Pdq1yI5uEuI+mKeoAVvi3wK/wk5/7okH84lkURfaiv3ZsLdn+4Gu5qLF?=
 =?us-ascii?q?meYXrpmt0BC3sFvhIiTOz2j12PSTpTZ3e0X6Ih6TA3EZmmApnfSYCwmryB3T?=
 =?us-ascii?q?u7H51PamBDDVCDDGrod4GaVPoXdiKSLdFukiYeWbiiVYAhzxeuuxH+y7Z9Ke?=
 =?us-ascii?q?rU4CIYv4r51Ndp/+3TiQ0y9TtsAsSZ0mGNSXx0n2wRSz8t06B+rldwykmM0a?=
 =?us-ascii?q?dmmfxUD99T6O1TUgc8K5Hcy/Z2C9foWgLOZt2JUkqpQs26ATEtSdI829APbk?=
 =?us-ascii?q?V8Fti5jRDMwTCqA7kLmLyPHpA09bjc33fpLcZn13nGzLUhj0UhQsZXKWKpnL?=
 =?us-ascii?q?V/+BbTBoLTiEWWi6aqer4B3C7D8GeM03COsVpZUA52TaXKQ3QfalHKotT+40?=
 =?us-ascii?q?PIV6WuBqg/Mgtd1c6CLbNHat/sjVVBXvfjItXeY3mqlme2HxmIw62DbIvwd2?=
 =?us-ascii?q?UaxiXdB1AOkxoP8naeKQg+GiChrnraDDxzCVLvZFjh8epgp3OhSE870QWKY1?=
 =?us-ascii?q?dm17qv9R4fneacRO8L3rIYpCchrC15HE2j0N3MDdqMvQhhcL9AbtM9+ldH1H?=
 =?us-ascii?q?nZtxB6Ppy4L6BtmEQecx9wv0PozBh3C4NAkdQ0o3Mu1gZ9NaWY0FYSPw+fiL?=
 =?us-ascii?q?L5IL7ULSHJ9ROsaqjb3BmK0t+M+aQIru8xqFbiugyvPk4j9Wh3ldhTz3aYoJ?=
 =?us-ascii?q?7NCVxWGZbwVFsnsgN3rKzAYzUsoobT2WBoPIGqvTLYndEkHu0ozlCnZdgbeK?=
 =?us-ascii?q?eFEhLiVtYVF+CwJ+Ew3VukdBQJOKZV7qFwd9P2KdOF1bStMeImmyip3kpd54?=
 =?us-ascii?q?Uo6V6B7ypxTKbz2p8Bx/yJll+cWyzUkEaqssexn5tNIz4VADzsmmDfGIdNa/?=
 =?us-ascii?q?gqLs4wAmC0Lpjyn4gvig=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2BMAAANxxRd/wHyM5BlHQEBBQEHBQGBVAcBCwGBbCqBO?=
 =?us-ascii?q?wEyhEGTPgEBAQEBAQaBCQgliVmPFBSBZwkBAQEBAQEBAQE0AQIBAYRAAoMAI?=
 =?us-ascii?q?zUIDgEDAQEBBAEBAQEEAQFsikOCOikBgmcBBSMVQRALGAICJgICVwYBDAgBA?=
 =?us-ascii?q?YJfP4F3FKV3gTKFR4MvgUaBDCgBi14XeIEHgTgMgl8+hBEBDAYBgymCWASUU?=
 =?us-ascii?q?pVUCYIZgh+RUAYbl16NKZkYAzNncSsIAhgIIQ+DKJEgIwOBNgEBi1MOF4IsA?=
 =?us-ascii?q?QE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 27 Jun 2019 13:41:50 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5RDfmJd024291;
        Thu, 27 Jun 2019 09:41:49 -0400
Subject: Re: LSM module for SGX?
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-security-module@vger.kernel.org, linux-sgx@vger.kernel.org,
        x86@kernel.org
Cc:     casey.schaufler@intel.com, jmorris@namei.org, luto@kernel.org,
        sean.j.christopherson@intel.com
References: <320da9183c7e9ae2c63982d5e124054a615c4b99.camel@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <496ea018-2655-a438-bc6b-80330c36cd11@tycho.nsa.gov>
Date:   Thu, 27 Jun 2019 09:41:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <320da9183c7e9ae2c63982d5e124054a615c4b99.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/27/19 8:56 AM, Jarkko Sakkinen wrote:
> Looking at the SGX-LSM discussions I haven't seen even a single email
> that would have any conclusions that the new hooks are the only possible
> route to limit the privileges to use SGX.
> 
> An obvious alternative to consider might be to have a small-scale LSM
> that you could stack. AFAIK Casey's LSM stacking patch set has not yet
> landed but I also remember that with some constraints you can still do
> it. Casey explained these constraints to me few years ago but I can't
> recall them anymore :-)
> 
> One example of this is Yama, which limits the use of ptrace(). You can
> enable it together with any of the "big" LSMs in the kernel.
> 
> A major benefit in this approach would that it is non-intrusive when it
> comes to other architectures than x86. New hooks are not only
> maintenance burden for those who care about SGX but also for those who
> have to deal with LSMs.

Regardless of whether or not you or anyone else creates such a 
small-scale LSM, we would still want to be able to control the loading 
of enclaves and the creation of executable enclave mappings via SELinux 
policy, so the hooks would be necessary anyway.

