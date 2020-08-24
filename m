Return-Path: <SRS0=VWZs=CC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,RCVD_ILLEGAL_IP,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10C6C433E1
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Aug 2020 13:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B944A204FD
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Aug 2020 13:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="t8vb7W0P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHXNlS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Aug 2020 09:41:18 -0400
Received: from mail-bn7nam10on2102.outbound.protection.outlook.com ([40.107.92.102]:49761
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727798AbgHXNhE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Aug 2020 09:37:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJFNsQ7g998WH6NSRW606Cp3DqMO8J7x0a+GLAiqs7f+491UBSVt8hV48QfKCMi9fjB/in9ystEMmuVfwNygd2DCQ/CPYw4Ugky8EaPJsvaA0IzL8EEHB+5U14YoQgyxUX5So+vEb4mBqiP9z+fnhGlzXlij12cBGvdO+eQ1P9w9gCrNJOyAxo72Hw4/mwa3Hs7DURcq563Sy0jeiLDan620g4fr1beJorVF+5TgrE5+3AI8rBdBYcP6W7c7TkC3KZhr7Oisn3rg2UPIsjqXF8Q1aYXR+CoocrOFhlrxqUe4HA4E6Raoz07GEMffxN1l2DqePlGL14/vzVJIbu4WYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7Yw7ioPWHa4MFCItXw+9JTFJLjLR4QW9xX6zxGc1LI=;
 b=a8NdWI/hKp8pFhPen3LudXO5ZSLP70Nfyv8Q6mtea0JKT+1/sfAat+xC23+amXek8FQKPF5AiwOfbuKhOqCNSTHjyTM+NorCxxWYMGR3FvSOSmyZGGUbJY2M+YHVNeEKvY6nX9QCVNn9qFIZferNj92+MmjSJekn4vXUIqO28p/USSyDs7HEZan1bvjhkdZ6O+cXFbGh3xrfhBoZCaAjA63mqhokBjEQgKMZtNsF24/u6T3pRCgs3VAw9Uz1stQONXSSS52V+GpidX5UlZAh3VG0sdm+1GiI9En/GNny7JLVWlrZlhv5iz0sUIS1G20Ujsllg343ctjiW2f92/jekA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7Yw7ioPWHa4MFCItXw+9JTFJLjLR4QW9xX6zxGc1LI=;
 b=t8vb7W0Pv6HmXQlbmISv3zMowVEAR7dbQXrQa4ZyWjBYo0buvVPsYSb8PVKkQL0g9kRL/eLF80elYsgfDFLkN+yA+sCOeLtp56bn4E6akONVJkiwCoOZMhfcqvD1tY77R/Yrhgvt82C9UIv6u/pB99f6tZPu7I6LH7q0siiL/5E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Mon, 24 Aug
 2020 13:36:35 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 13:36:35 +0000
Subject: Re: [RFC PATCH 4/4] x86/vdso: x86/sgx: Allow the user to exit the
 vDSO loop on interrupts
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-5-sean.j.christopherson@intel.com>
 <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
 <6109f3e1-0579-67c6-0a02-f9b931ba1fac@fortanix.com>
 <CALCETrW94nC5jtQcn7tCMm4itrGSbpxSadtyQUJ=UcR4bFPJ4Q@mail.gmail.com>
 <8603e74e-6484-6e28-164f-2b0f908d5986@fortanix.com>
 <CALCETrVTxdssjtp1+E8RH5wek2FauJTmJhGqp8taBzXVSm6VFQ@mail.gmail.com>
 <9d3e6c56-c491-3449-9d29-ee566e994d4e@fortanix.com>
 <CALCETrWAKLSGS-UuZcegnPSOLSh-7D9AjB82fZ7+or5hvVzj_w@mail.gmail.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <46938c15-24e7-ee80-0cdc-0b35c5a19697@fortanix.com>
Date:   Mon, 24 Aug 2020 15:36:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALCETrWAKLSGS-UuZcegnPSOLSh-7D9AjB82fZ7+or5hvVzj_w@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080307000604090509000304"
X-ClientProxiedBy: AM3PR03CA0076.eurprd03.prod.outlook.com
 (2603:10a6:207:5::34) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by AM3PR03CA0076.eurprd03.prod.outlook.com (2603:10a6:207:5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Mon, 24 Aug 2020 13:36:33 +0000
X-Originating-IP: [213.127.112.210]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0dbcf242-bb7e-4139-86a6-08d84832b816
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3672153449A4A0EB9E14207FAA560@BYAPR11MB3672.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VL9Bj2hdWk/kJ11CIMrL7F5LWzTYWaHFm+XhwkwqmA/3xszEUA4hQRR6s+gO7D5RhRuY/Wpc9TlP9+6C7pSvN7tn0D4nGmtZMIWGPZMlfIo1JCQBFNNam89XLkwTUssyFC4gC0Y9lHfUSItoc/AVMnC2HTr7tJm2VSbC0XW/xIV2ZWhze4PIg1Yusz5bBbcJe1q4QY6qba8kQzdSSP2Vi2y1EJNZ27JWM/ruXuWqU+3RSxkmJ/uumzCl0GFB9B+HOTTTMbqeCNn2f6VF+An7InCLWgzSUq8sS7HsKvEf25qzQ/9DKZAipQPtiguLqwzujYKmnAcB7n41xGMDL/TdQujbi64kA/jtxCjafawnpJSRqYcz+hAOejnowz/qkbio
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39830400003)(366004)(2616005)(6486002)(26005)(31696002)(956004)(53546011)(86362001)(54906003)(16576012)(2906002)(33964004)(8936002)(6666004)(6916009)(8676002)(186003)(4326008)(31686004)(66556008)(66476007)(316002)(66946007)(36756003)(235185007)(478600001)(5660300002)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: FG/UmvEsUhFtRonagp6n4mV3L1eu3LslWrc2Ga0AAUZV1GdbAEL3+65u/cJLPNFXn56e26IUq/OUnJeua5EIJdkFTzcF2N/BKq4qWOA/F7MjB2mtpoY35wq+1HyFZniCW7vbeQr1qo1d1pdh79SXWzkuM7rDobt/ASjGXvwde8VOtt/iO2oW1KO6BD4RrnUbpwKBN0GViz8BitsSnpALR9jUK/1v9/iTBydOQcOxcDCaqZr481w6R63o0/yJfeATjM99+AtunG9Y6+ISyZQQQ4GeYZnthzRfrIGio70rTWESjzo09KdlRCQ2lMyRgjSEM622Cv/3fD+EhLoHKjh+4rMoPZv6qiAiZN07uPmf3C4+KIga9Sk7HtUMiSaZrzn96xIqo9cGD+chJvyuG+dAGaX1KjZbRqgmJSWXJpA19vo45ozQElvipR8b1/lhqu/4zrTMOP99t6OzAFyZlzy/iOyBAMGNAO3WsptZ85A7nEKVz6q9N8NBJOC/iVQ4qt47jsE5ShiZb+OUsdnnt8XbTywah17R5fkwTcLcXbsC1KzZSaLUATJmItpzlUGniVmWteAahtNFY1R8hEXLSRLlkwKDAoobvVQgE1BRa/DxqxDdS+HHo0qZx48jcw8vHR/fhbs1gkhQYdaAWi/y6o0NuA==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbcf242-bb7e-4139-86a6-08d84832b816
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2020 13:36:34.8323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7QpY7CGjAko1F8ih7ucJDD4yv0G7LKNpmD+/IGUDSmVzyUbvcxxbF7aHNIB/oYQBKSXaedh+yTgUkNEC6OlJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3672
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080307000604090509000304
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-22 23:55, Andy Lutomirski wrote:
> On Thu, Aug 20, 2020 at 10:53 AM Jethro Beekman <jethro@fortanix.com> w=
rote:
>>
>> On 2020-08-20 19:44, Andy Lutomirski wrote:
>>> This is a genuine semantic question: is __vdso_sgx_enter_enclave()
>>> like read on a pipe (returns -EINTR on a signal) or is it more like a=

>>> restartable syscall or a normal library function that just keeps
>>> running if your signal handler does nothing?  You could siglongjmp()
>>> out, but that's a bit gross.
>>>
>>> I wouldn't object to an option to __vdso_sgx_enter_enclave() to make
>>> it return -EINTR if signaled by a non-SA_RESTART signal.  Implementin=
g
>>> it might be distinctly nontrivial, though.
>>>
>>> But this isn't what this patch does, and I suspect we've been talking=

>>> past each other.  This patch makes __vdso_sgx_enter_enclave() return
>>> if there's an *interrupt*.  If you push a keyboard button, move your
>>> mouse, get a network interrupt on that core, etc, it will return.
>>> This is nonsense.
>>
>> It's not nontrivial to return on signals, this patch does it. This pat=
ch *also* returns when there's a HW interrupt, but that's not important.
>=20
> Allow me to quote the changelog of the patch:
>=20
> This allows the user's runtime to switch
> contexts at opportune times without additional overhead, e.g. when usin=
g
> an M:N threading model (where M user threads run N TCSs, with N > M).
>=20
> NAK.
>=20
>>
>> It sounds like you're saying you want to subdivide AEXs into =E2=80=9C=
interrupts that lead to user-observable signals=E2=80=9D and =E2=80=9Coth=
er interrupts=E2=80=9D, and then hide the second category from the user. =
I wouldn't object to that, but I don't know how to code this. It seems li=
ke a lot of work compared to the obvious solution (this patch).
>=20
> The obvious solution is NAKked.
>=20
> Does siglongjmp() really not work for you?

Allow me to quote the changelog of "[PATCH v36 18/24] x86/vdso: Add suppo=
rt for exception fixup in vDSO functions":

Putting everything together, userspace enclaves will utilize a library
that must be prepared to handle any and (almost) all exceptions any time
at least one thread may be executing in an enclave.  Leveraging signals
to handle the enclave exceptions is unpleasant, to put it mildly, e.g.
the SGX library must constantly (un)register its signal handler based
on whether or not at least one thread is executing in an enclave, and
filter and forward exceptions that aren't related to its enclaves.  This
becomes particularly nasty when using multiple levels of libraries that
register signal handlers, e.g. running an enclave via cgo inside of the
Go runtime.


If I could use signal handlers I wouldn't use the VDSO call. (Corollary: =
if I wasn't using the VDSO call, I wouldn't have to think about this beca=
use what I want is already supported).

--
Jethro Beekman | Fortanix


--------------ms080307000604090509000304
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
C54wggVPMIIEN6ADAgECAhAFFr+cC0ZYZTtbKgQCBwyyMA0GCSqGSIb3DQEBCwUAMIGCMQsw
CQYDVQQGEwJJVDEPMA0GA1UECAwGTWlsYW5vMQ8wDQYDVQQHDAZNaWxhbm8xIzAhBgNVBAoM
GkFjdGFsaXMgUy5wLkEuLzAzMzU4NTIwOTY3MSwwKgYDVQQDDCNBY3RhbGlzIENsaWVudCBB
dXRoZW50aWNhdGlvbiBDQSBHMTAeFw0xOTA5MTYwOTQ3MDlaFw0yMDA5MTYwOTQ3MDlaMB4x
HDAaBgNVBAMME2pldGhyb0Bmb3J0YW5peC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDHWEhcRGkEl1ZnImSqBt/OXNJ4AyDZ86CejuWI9jYpWbtf/gXBQO6iaaEKBDlj
Vffk2QxH9wcifkYsvCYfxFgD15dU9TABO7YOwvHa8NtxanWr1xomufu/P1ApI336+S7ZXfSe
qMnookNJUMHuF3Nxw2lI69LXqZLCdcVXquM4DY1lVSV+DXIwpTMtB+pMyqOWrsgmrISMZYFw
EUJOqVDvtU8KewhpuGAYXAQSDVLcAl2nZg7C2Mex8vT8stBoslPTkRXxAgMbslDNDUiKhy8d
E3I78P+stNHlFAgALgoYLBiVVLZkVBUPvgr2yUApR63yosztqp+jFhqfeHbjTRlLAgMBAAGj
ggIiMIICHjAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFH5g/Phspz09166ToXkCj7N0KTv1
MEsGCCsGAQUFBwEBBD8wPTA7BggrBgEFBQcwAoYvaHR0cDovL2NhY2VydC5hY3RhbGlzLml0
L2NlcnRzL2FjdGFsaXMtYXV0Y2xpZzEwHgYDVR0RBBcwFYETamV0aHJvQGZvcnRhbml4LmNv
bTBHBgNVHSAEQDA+MDwGBiuBHwEYATAyMDAGCCsGAQUFBwIBFiRodHRwczovL3d3dy5hY3Rh
bGlzLml0L2FyZWEtZG93bmxvYWQwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMIHo
BgNVHR8EgeAwgd0wgZuggZiggZWGgZJsZGFwOi8vbGRhcDA1LmFjdGFsaXMuaXQvY24lM2RB
Y3RhbGlzJTIwQ2xpZW50JTIwQXV0aGVudGljYXRpb24lMjBDQSUyMEcxLG8lM2RBY3RhbGlz
JTIwUy5wLkEuLzAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRI
Q0wtRzEvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUAXkM7yNq6pH6j+IC/7IsDPSTMnowDgYDVR0P
AQH/BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4IBAQC8z+2tLUwep0OhTQBgMaybrxTHCxRZ4/en
XB0zGVrry94pItE4ro4To/t86Kfcic41ZsaX8/SFVUW2NNHjEodJu94UhYqPMDUVjO6Y14s2
jznFHyKQdXMrhIBU5lzYqyh97w6s82Z/qoMy3OuLek+8rXirwju9ATSNLsFTzt2CEoyCSRtl
yOmR7Z9wgSvD7C7XoBdGEFVdGCXwCy1t9AT7UCIHKssnguVaMGN9vWqLPVKOVTwc4g3RAQC7
J1Aoo6U5d6wCIX4MxEZhICxnUgAKHULxsWMGjBfQAo3QGXjJ4wDEu7O/5KCyUfn6lyhRYa+t
YgyFAX0ZU9Upovd+aOw0MIIGRzCCBC+gAwIBAgIILNSK07EeD4kwDQYJKoZIhvcNAQELBQAw
azELMAkGA1UEBhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3RhbGlzIFMucC5B
Li8wMzM1ODUyMDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlvbiBSb290IENB
MB4XDTE1MDUxNDA3MTQxNVoXDTMwMDUxNDA3MTQxNVowgYIxCzAJBgNVBAYTAklUMQ8wDQYD
VQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4v
MDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENB
IEcxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwPzBiVbZiOL0BGW/zQk1qygp
MP4MyvcnqxwR7oY9XeT1bES2DFczlZfeiIqNLanbkyqTxydXZ+kxoS9071qWsZ6zS+pxSqXL
s+RTvndEaWx5hdHZcKNWGzhy5FiO4GZvGlFInFEiaY+dOEpjjWvSeXpvcDpnYw6M9AXuHo4J
hjC3P/OK//5QFXnztTa4iU66RpLteOTgCtiRCwZNKx8EFeqqfTpYvfEb4H91E7n+Y61jm0d2
E8fJ2wGTaSSwjc8nTI2ApXujoczukb2kHqwaGP3q5UuedWcnRZc65XUhK/Z6K32KvrQuNP32
F/5MxkvEDnJpUnnt9iMExvEzn31zDQIDAQABo4IB1TCCAdEwQQYIKwYBBQUHAQEENTAzMDEG
CCsGAQUFBzABhiVodHRwOi8vb2NzcDA1LmFjdGFsaXMuaXQvVkEvQVVUSC1ST09UMB0GA1Ud
DgQWBBR+YPz4bKc9Pdeuk6F5Ao+zdCk79TAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaA
FFLYiDrIn3hm7YnzezhwlMkCAjbQMEUGA1UdIAQ+MDwwOgYEVR0gADAyMDAGCCsGAQUFBwIB
FiRodHRwczovL3d3dy5hY3RhbGlzLml0L2FyZWEtZG93bmxvYWQwgeMGA1UdHwSB2zCB2DCB
lqCBk6CBkIaBjWxkYXA6Ly9sZGFwMDUuYWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRo
ZW50aWNhdGlvbiUyMFJvb3QlMjBDQSxvJTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIw
OTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0
cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAO
BgNVHQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQELBQADggIBAE2TztUkvkEbShZYc19lifLZej5Y
jLzLxA/lWxZnssFLpDPySfzMmndz3F06S51ltwDe+blTwcpdzUl3M2alKH3bOr855ku9Rr6u
edya+HGQUT0OhqDo2K2CAE9nBcfANxifjfT8XzCoC3ctf9ux3og1WuE8WTcLZKgCMuNRBmJt
e9C4Ug0w3iXqPzq8KuRRobNKqddPjk3EiK+QA+EFCCka1xOLh/7cPGTJMNta1/0u5oLiXaOA
HeALt/nqeZ2kZ+lizK8oTv4in5avIf3ela3oL6vrwpTca7TZxTX90e805dZQN4qRVPdPbrBl
WtNozH7SdLeLrcoN8l2EXO6190GAJYdynTc2E6EyrLVGcDKUX91VmCSRrqEppZ7W05TbWRLi
6+wPjAzmTq2XSmKfajq7juTKgkkw7FFJByixa0NdSZosdQb3VkLqG8EOYOamZLqH+v7ua0+u
lg7FOviFbeZ7YR9eRO81O8FC1uLgutlyGD2+GLjgQnsvneDsbNAWfkory+qqAxvVzX5PSaQp
2pJ52AaIH1MN1i2/geRSP83TRMrFkwuIMzDhXxKFQvpspNc19vcTryzjtwP4xq0WNS4YWPS4
U+9mW+U0Cgnsgx9fMiJNbLflf5qSb53j3AGHnjK/qJzPa39wFTXLXB648F3w1Qf9R7eZeTRJ
fCQY/fJUMYID9jCCA/ICAQEwgZcwgYIxCzAJBgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8x
DzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5Njcx
LDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZY
ZTtbKgQCBwyyMA0GCWCGSAFlAwQCAQUAoIICLzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjQxMzM2MjlaMC8GCSqGSIb3DQEJBDEiBCB8iU+1fJZ+
Dlx5RBIstwqTlMmAhn6nUEiI0cNQMTfyJjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEARYEPrVOoGWBwYcyTx3XO1yC2qDWxFk8br3TsNojGUQi6bupPSBmyv0zQ
jEXGnlUNN0E9cFMl1lIz0WuCzTYQ2w2hOsqtpSz9BKaJEfyoRGo0l+R37U1G5TCurzkPlilL
Gd1rju9M3NJAq/186oPLTXBq9D6eHfu2ANRSbF2lJOGGnMuoIWOAR2CrRjgDdjciGlV5lBOT
a0Yi4/R2X++lgdUY8R7n/cVrQYVxqB1kijRkt9S7KvGK4b4kItMMiZawkWCA4nyAaCr87kVV
AFKGyoCtuFygmkrmp2vOFrURHNB3SZYMBwznY+UH8upQko2DpckSVoqC/Bpk/HCJDjhybAAA
AAAAAA==

--------------ms080307000604090509000304--
