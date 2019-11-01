Return-Path: <SRS0=mxub=YZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB283CA9ECF
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Nov 2019 17:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8166521734
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Nov 2019 17:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="UF+y64Tf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfKARYP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Nov 2019 13:24:15 -0400
Received: from USFB19PA34.eemsg.mail.mil ([214.24.26.197]:10799 "EHLO
        USFB19PA34.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbfKARYP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Nov 2019 13:24:15 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Nov 2019 13:24:14 EDT
X-EEMSG-check-017: 23164733|USFB19PA34_ESA_OUT04.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.68,256,1569283200"; 
   d="scan'208";a="23164733"
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by USFB19PA34.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 01 Nov 2019 17:17:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1572628625; x=1604164625;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=QiHlHmE2+QQOed40SDVhrg0abgVoVKik9aetLNElYPI=;
  b=UF+y64TfuqaW+ihgvXgjZxe+R78kPTrJ6w0MF/pVl0908kF31sgrWrmZ
   iuIiS2UuaboV2UiL53pEMT0x6+E6zeGRFW9BOrnGEViIyO37W/Kvnfi95
   GYFA0QJF2PP3V3KNfJHn14m60GGcrLC6wYjxizkSnryxYIVfYH3jsFY7d
   Z9FPmi0Y3C6cIxZiss6adOd56JelDBwMw7alCZPPPMgmeBUQexIEWiuJD
   yuCjaAAWdsI/kPOFsi5HGt7k04s9SKibdUmjS4OOJTGvYhIMUFUM6so26
   tWqW9WA/6B3EH2p4+faljHRFJcCIbk6+8cUZtOiiRjos/moxaUlld1Vzb
   A==;
X-IronPort-AV: E=Sophos;i="5.68,256,1569283200"; 
   d="scan'208";a="35004249"
IronPort-PHdr: =?us-ascii?q?9a23=3AWdK6VhCsw63xARb81HgwUyQJP3N1i/DPJgcQr6?=
 =?us-ascii?q?AfoPdwSP75pM6wAkXT6L1XgUPTWs2DsrQY0rGQ6vi/Ej1Qqb+681k6OKRWUB?=
 =?us-ascii?q?EEjchE1ycBO+WiTXPBEfjxciYhF95DXlI2t1uyMExSBdqsLwaK+i764jEdAA?=
 =?us-ascii?q?jwOhRoLerpBIHSk9631+ev8JHPfglEnjWwba58IRmssAndqssbjYRmJ6sy1x?=
 =?us-ascii?q?DEvmZGd+NKyG1yOFmdhQz85sC+/J5i9yRfpfcs/NNeXKv5Yqo1U6VWACwpPG?=
 =?us-ascii?q?4p6sLrswLDTRaU6XsHTmoWiBtIDBPb4xz8Q5z8rzH1tut52CmdIM32UbU5Ui?=
 =?us-ascii?q?ms4qt3VBPljjoMOiUn+2/LlMN/kKNboAqgpxNhxY7UfJqVP+d6cq/EYN8WWX?=
 =?us-ascii?q?ZNUsNXWiNPGIO8a5YEAfQHM+hWsoLxo0ICoBu6CAWpAu7k1z1GiWLs3aAizu?=
 =?us-ascii?q?ovDw/G0gwjEdwAvnvbo9f6O7sdX+2u0KnFzi/OY+9K1Trz6oXFdA0qr/GWXb?=
 =?us-ascii?q?J3dMrc0VQhFx/bgVWIqYzqITWV3fkQvWie9eVgUeavhHAnqgpspTWv3dojip?=
 =?us-ascii?q?LSi4IJylHL6SV5wIEvKd2+U050e8SoEJRXtyGELoZ7RN4pTWJwuCsi17ELtp?=
 =?us-ascii?q?G2cDIKxZg63RLTdfOKf5aS7h7+UuuaPC12i2h/eL2lgha/6U2gyurhWcaqyF?=
 =?us-ascii?q?tKtS9FksXUtnAKyhzT9tCLSvtj8Uel3jaCzxzT5fteIUA1iKrbMIQtwqIwl5?=
 =?us-ascii?q?UPsUTDGTX6mEPqg6+Nakoo4O2o6+XjYrn+p5+cMZF7ih3mP6gzlcGyDv40Pw?=
 =?us-ascii?q?gTU2SB5+ix26Pv8VfkTLlSi/05iKjZsJTUJcQBoa65BhdY0p0+5BakFDqmzN?=
 =?us-ascii?q?QZkmUHLFJCYh6HiZPpNEvULPD3Cve/nUygkC13yPDeIr3hHpLNI2DYkLj/Z7?=
 =?us-ascii?q?l97VRQyAgpwd9D55JUELABIOnvWk/2rNzYDgE2Mxavw+bgDtVwzYIeWWSTAq?=
 =?us-ascii?q?CHNKPeq0OH5uUqI+OUfo8apC79K+Q55/7plXI5m0USfbOq3ZsUb3C0BO9mLF?=
 =?us-ascii?q?+aYXrvg9cBF3kFvgwlQezuiV2CVyNTZnmoU6I94DE7FJypDYPZSo+xh7yB2T?=
 =?us-ascii?q?+xHodKaWBeFlCMDXDoep2AW/cNbiKSP8BgniUHVbe/UY8h0w+htAvhxrp5Ie?=
 =?us-ascii?q?rb5DcYuYjg1Ndr/e3Tkw899ThuA8SayWGNQHl+nnkUSD8uwKB/vUt9x0+M0K?=
 =?us-ascii?q?V7gvFVDt9T6O1TUgc8K5Hcy/Z2C9foWgLOZt2JUkqpQs26ATEtSdI829sOY0?=
 =?us-ascii?q?d7G9W/gRHPxjGqA7AalrGQGpw0/bzT32LrK8Z+1XnGzq8hgEciQsdVMm2mnK?=
 =?us-ascii?q?F//RDJB4HVi0WZi7qqdaME0SHX92eD1W+OsVpcUA5xV6XFQH8ealLYrdT++0?=
 =?us-ascii?q?PCSaKhBq47MgtAzs6CLLFGatrzjVVJXP3jIsjRY3qtm2esAhaF3q6DY5D0e2?=
 =?us-ascii?q?oDxindCFILkwYI/XmYMwgzHSaho2TCDDNwEVLjeV/j8e57qHmjVE870xmKb1?=
 =?us-ascii?q?F917qy4hMVg/ycS/QJ3rIBoighrS55HEyj0N3LC9qPvRZhcL9AbtM65VdNzX?=
 =?us-ascii?q?jZuBBlPpy8M6BigUYTcwJvv0Pryxp4Fp9PkcwurHM3yQp/MriY301ceDOYx5?=
 =?us-ascii?q?/wJqfbJXX1/BCqc6TWwE3R0M6K+qcT7/Q1s07jsx+zFkot7XprycNa0nub5p?=
 =?us-ascii?q?XXCgofSpPxUkAr9xdko7HWeDUy54TR1Xd0K6m7rifC2841BOsi0hugZNdfP7?=
 =?us-ascii?q?mEFQPoEM0VHdSuKe0zl1modB0EOeFS9LQvMsOncfuGxLCkPOJ6kD26imRH5Z?=
 =?us-ascii?q?h30liQ+CpkVu7Iw5EFzumY3gSdVjf8kE2ussftlYBEeDEdBGy/ySf/CY5QYK?=
 =?us-ascii?q?1yYZgECWO0L8KrwdV+gobnW2RE+167G1MGxMipdAKIYFz7wAJQz0UXoHy9lS?=
 =?us-ascii?q?ujzzx7jS8pobaf3CPQxeTidx0HN3VPRGlji1fsPIe1g8obXEiucwgmih+l6V?=
 =?us-ascii?q?zmyKhcoaR1N3PTTltQfyjqM2FiVbO9tqaNY85L55IlqiFXUOW6YVCHVr79uR?=
 =?us-ascii?q?wa0yXiH2pR3jw0ai+lsI3jnxNmkGKdMGpzrH3BdMFz3xjf5cbQReVP3jUcRC?=
 =?us-ascii?q?l4jyLaBlm6P9m149qUk43Pvfy5V2KkTpdTazXkzZuctCun4m1nGQawn+iol9?=
 =?us-ascii?q?L9FQg60DH0199pWCnSsRnzfJHh176mPuJ/YkloGFj85tJ4GoF5iYswhIod2X?=
 =?us-ascii?q?odhpWO/XoHjX3zMdRD2aL6cnUNWSILz8TS4Aj/101pNmiJyJ7hVnWB3sthYM?=
 =?us-ascii?q?G3YmcL2iIh6MBHE6SU46JenStzvFW4qRjdYf9nnjcS0fEu8mIVg/kVuAoxyS?=
 =?us-ascii?q?WQGrMSElNZPSD2lxSI8sqxrKNYZGu0cLiw0lZ+ks6lDL2Yvg5cX3P5cI84HS?=
 =?us-ascii?q?Bs9sV/LE7M0Hrr54H+ednfc9QTtgGWkxjelOhYM50xlv0NhSpoPWLyo2cpxP?=
 =?us-ascii?q?I8jRxrxZu6ppSIK31x/KKlBR5VLiH6aN0O9TH3jKZRgtya3o+uHpVnFTUGR5?=
 =?us-ascii?q?roTfS0ED0MsfTrLRqBEDo5qn2DA7rQARef6Ft6r3LIC52rL2yXJHgFzdp8Xh?=
 =?us-ascii?q?mcKk1fgAIXXDghhJ42CB2lxMz7f0dl/Dwe+ln4qh5UwOJyKxb/SnvfpBuvaj?=
 =?us-ascii?q?osTJifLRxW7hxN5kvMKsyR8P58HzxC/p2gsAyMKnWXZwFPDW4UR0yEA07sM6?=
 =?us-ascii?q?Kw5dnP7eeYHPCyL/jQbrWUr+xRSfOIyYio0ot88DaGLt+PMWV6D/0nxkpDWm?=
 =?us-ascii?q?h0G9/EmzUVVSMXjCLNY9SAqxum4S13r92w/+nrWA31/oaPCr1SMclx9BCym6?=
 =?us-ascii?q?uMK+mQhCMqYQpfg6gBzHmA47gF3UUOjDlueiO2FrJI4TXARaSWmOlcDwQacD?=
 =?us-ascii?q?90LMtF9bk72CFMP9LWjpX+0bsu3dAvDFIQbkDsgsGkY4QxJmi5MF7WTBKQOK?=
 =?us-ascii?q?+uOSzAw8axZ7i1D7JXkrMH5FWLpT+HHhq7bXy4nD7zWkXqaLwdgQ=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2DGAQDCZ7xd/wHyM5BlGwEBAQEBAQEFAQEBEQEBAwMBA?=
 =?us-ascii?q?QGBfYF0LIFAATKEUo8LVAaBESWJY5FCCQEBAQEBAQEBATQBAgEBhEACg3skO?=
 =?us-ascii?q?BMCDgEBAQQBAQEBAQUDAQFshUOCOykBgm0BBSMPAQVBEAsYAgImAgJXBg0IA?=
 =?us-ascii?q?QGCXz+CUyWzAIEyhU6DNoFIgQ4ojBEYeIEHgREnDIJfPodVgl4ErXKCLoIzi?=
 =?us-ascii?q?XyJAAYbgjyMC4seqiUigVgrCAIYCCEPgyhPERSRaCUDgTUBAY1lAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 01 Nov 2019 17:17:03 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id xA1HH07N027102;
        Fri, 1 Nov 2019 13:17:00 -0400
Subject: Re: [PATCH v23 12/24] x86/sgx: Linux Enclave Driver
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
 <173a196e-fa6b-23b8-c818-dfca6cdadcc6@tycho.nsa.gov>
 <20191031211721.GD10507@linux.intel.com>
 <f91d788c-b372-8e2f-7ffb-995f501b5d6b@tycho.nsa.gov>
 <4bf866ae-adc8-7902-3714-b62e548d8584@tycho.nsa.gov>
 <20191101153238.GA2657@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <f3a3d137-a187-9090-f5af-da306ced5371@tycho.nsa.gov>
Date:   Fri, 1 Nov 2019 13:16:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191101153238.GA2657@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 11/1/19 11:32 AM, Sean Christopherson wrote:
> On Fri, Nov 01, 2019 at 09:28:17AM -0400, Stephen Smalley wrote:
>> On 11/1/19 9:16 AM, Stephen Smalley wrote:
>>> So, IIUC, that means that merging the driver will create a regression with
>>> respect to LSM control over executable mappings that will only be
>>> rectified at some future point in time if/when someone submits LSM hooks
>>> or calls to existing hooks to restore such control.  That doesn't seem
>>> like a good idea.  Why can't you include at least that basic level of
>>> control now?  It is one thing to defer finer grained control or
>>> SGX-specific access controls to the future - that I can understand.  But
>>> introducing a regression in the existing controls is not really ok.
>>
>> Unless you are arguing that the existing checks on mmap/mprotect of
>> /dev/sgx/enclave are a coarse-grained approximation (effectively requiring
>> WX to the file or execmem for any user of SGX).
> 
> Yes, that's the argument as running any enclave will require RWX access to
> /dev/sgx/enclave.  EXECMEM won't trigger for SGX users as /dev/sgx/enclave
> must be MAP_SHARED and it's a non-private file (not backed by anonymous
> inode, in case I got the file terminology wrong).

Ok, so for SELinux's purposes, one will need to allow :file { open ioctl 
map read write execute } to whatever type is ultimately assigned to 
/dev/sgx/enclave in order to use SGX.
